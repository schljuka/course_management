package Course::Management;
use Mojo::Base 'Mojolicious', -signatures;
use YAML qw(LoadFile);

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  my $home=$self->app->home;
  $home->detect;

  my $config_course = LoadFile($home->child($config->{course_config}));

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/' => {cc=>$config_course})->to('example#welcome');
  $r->get('/course/:id' => {cc=>$config_course})->to('course#list_exercises');
  $r->post('/upload' => {cc=>$config_course})->to('course#upload');
}
 
1;
