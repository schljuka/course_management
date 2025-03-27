:package Course::Management::Controller::Main;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use List::MoreUtils qw(uniq); 
use List::Util qw(any); 
use Data::UUID;



sub welcome ($self) {
   $self->render();
}

sub login ($self){
   my $cc = $self->course_config;
   my $email = lc $self->param('email');
   $email =~ s/\s+//;
   $email =~ s/\s+$//;

   my @emails = uniq map { $_->{email} } map { @{ $_->{students} }} @$cc;
   my $success = any {$_ eq $email} @emails;
  
   $self->app->log->info($email);
   
   if(not $success){
   return $self->render(email=>$email, success=>$success)
   };

   my $ug = Data::UUID->new;
   my $uuid = $ug->create;
   my $code = $ug->to_string($uuid); 
   $self->app->log->info($code);

   sendmail($email, $code);

   $self->render(email=>$email,success=>$success, code=>$code)
}



sub sendmail {
  my ($email, $code)=@;	

}


1;
