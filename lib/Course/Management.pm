package Course::Management;
use Mojo::Base 'Mojolicious', -signatures;
use YAML qw(LoadFile);
use List::Util qw(any); 

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  my $home=$self->app->home;
  $home->detect;

  my $course_config = LoadFile($home->child($config->{course_config}));

  $self->helper(course_config => sub { state $course_config_data = $course_config });

  $self->helper(courses => sub($c, $student_email = undef) {
    my %courses;  
    my %student_courses;  
    for my $course (@$course_config) {
      $courses{$course->{id}} = $course->{name};
    }
    if ($student_email) {    
       for my $course (@$course_config) {
         if (any {$_->{email} eq $student_email} @{ $course->{students} }) {
             $student_courses{$course->{id}} = $course->{name};
         }
       }   
       return %student_courses; 
    } else {
       return %courses;  
    }
  });

  $self->helper(exercises => sub($c, $course_id) {
    my ($course_ref) = grep { $_-> {id} eq $course_id } @$course_config;
    return if not defined $course_ref;
    return @{$course_ref->{exercises}};
  });

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('main#welcome');
  $r->get('/course/:id')->to('course#list_exercises');
  $r->post('/upload')->to('course#upload');
  $r->post('/login')->to('main#login');
}
 
1;
