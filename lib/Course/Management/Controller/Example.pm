package Course::Management::Controller::Example;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub welcome ($self) {

  # Render template "example/welcome.html.ep" with message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
  # $self->render(json => {name=>"Pera"}, status => 200);
}

1;
