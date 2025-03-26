:package Course::Management::Controller::Main;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use List::MoreUtils qw(uniq); 
use List::Util qw(any); 

sub welcome ($self) {

   my $cc = $self->course_config;
   $self->render(cc=>$cc);
  
}


sub login ($self){
   my $cc = $self->course_config;
   my $email = $self->param('email');

   my @emails = uniq map { $_->{email} } map { @{ $_->{students} } } @{ $cc->{courses} }; 
   my $success = any {$_ eq $email} @emails;
  
   $self->app->log->info($email);
   $self->render(email=>$email,success=>$success)
  
}


1;
