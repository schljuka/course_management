package Course::Management;
use Mojo::Base 'Mojolicious', -signatures;
use YAML qw(LoadFile);
use Mojo::Home;
use Mojo::Home;

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  my $home=Mojo::Home->new;
  $home->detect;

  my $config_course = LoadFile($home->child($config->{course_config}));

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/' => {cc=>$config_course})->to('example#welcome');
  $r->get('/course/:id' => {cc=>$config_course})->to('course#list_exercises');
}
 
1;
