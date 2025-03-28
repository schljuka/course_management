package Course::Management::Controller::Course;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub list_exercises ($self) {
  my $id = $self->param('id');
  my $cc = $self->course_config;
  my ($course) = grep { $_->{id} eq $id } @{ $cc};
  $self->render(course=>$course,cc=>$cc);
}

sub upload ($self){
  my $id = $self->param('id');

  # Verify that the ID was indeed one of the IDs we have...
  my $cc = $self->course_config;
  my ($course) = grep { $_->{id} eq $id } @$cc;
  die $id if not $course;
  
  my $home = $self->app->home;
  $home->detect;

  my $upload = $self->req->upload('upload'); 
  my $dir->$home->child('data','hello');
  $dir->make_path;
  my $filename = $dir->child($upload->filename);
  $upload->move_to($filename);

  $self->render(course=>$course, cc=>$cc);
}

1;
 
