ipackage Course::Management::Controller::Main;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub welcome ($self) {

   my $cc = $self->course_config;
   $self->renderi(cc=>$cc);
  # $self->render(json => {name=>"Pera"}, status => 200);
  
}

1;
