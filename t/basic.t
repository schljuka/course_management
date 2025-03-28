no warnings 'experimental';
use experimental 'signatures';
use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Test::MockModule;
use YAML qw(LoadFile);

my $t = Test::Mojo->new('Course::Management');

my $config = $t->app->plugin('NotYAMLConfig');

my $home = $t->app->home;
$home->detect;

use Data::Dumper;
my $course_config = LoadFile($home->child($config->{course_config}));
warn Dumper($course_config);


subtest main => sub {
    $t->get_ok('/');

    $t->status_is(200);
    $t->content_like(qr/Welcome to the Course Management App/i);
    $t->content_like(qr/\Q$course_config->{courses}[0]{name}\E/);
    $t->text_is("#$course_config->{courses}[0]{id} a", $course_config->{courses}[0]{name});
};

subtest course => sub {
    $t->get_ok("/course/$course_config->{courses}[1]{id}");

    $t->status_is(200);
    $t->text_is("#exercises :first-child a", $course_config->{courses}[1]{exercises}[0]{title});
    $t->text_is(qq{a[href="$course_config->{courses}[0]{exercises}[1]{url}"]}, $course_config->{courses}[0]{exercises}[1]{title});
};

subtest login_failed => sub {
    my $called_sendmail;
    my $module = Test::MockModule->new('Course::Management::Controller::Main');
    $module->mock('sendmail', sub {
        note 'mocking sendmail';
        $called_sendmail = 1;
    });

    $t->post_ok('/login' => form => {email => 'foo@bar.com'});
    $t->status_is(200);
    $t->content_like(qr{Invalid email});
    ok !$called_sendmail, 'sendmail not called for invalid email';
};

subtest login => sub {
    my $called_sendmail;
    my $sent_email;
    my $sent_code;
    my $module = Test::MockModule->new('Course::Management::Controller::Main');

    no warnings 'experimental';
    $module->mock('sendmail', sub ($email, $code) {
        note 'mocking sendmail';
        $called_sendmail = 1;
        $sent_email = $email;
        $sent_code = $code;
    });

    $t->post_ok('/login' => form => {email => $course_config->[0]{students}[0]{email}});
    $t->status_is(200);
    $t->content_like(qr{We have sent an email to});
    ok $called_sendmail, 'sendmail';
    is $sent_email, $course_config->[0]{students}[0]{email};
    note "code: $sent_code";
    # visit $t->get_ok (/login/$sent_code);
    # $t->status_is(200);
    # visit http:// to see we are logged in
};

done_testing();
