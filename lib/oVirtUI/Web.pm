#!/usr/bin/perl

# COPYRIGHT:
#
# This software is Copyright (c) 2013 by René Koch
#                             <r.koch@ovido.at>
#
# This file is part of Monitoring UI-Plugin.
#
# (Except where explicitly superseded by other copyright notices)
# Monitoring UI-Plugin is free software: you can redistribute it 
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3 of 
# the License, or any later version.
#
# Monitoring UI-plugin is distributed in the hope that it will be 
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Monitoring UI-Plugin.  
# If not, see <http://www.gnu.org/licenses/>.


package oVirtUI::Web;

BEGIN {
    $VERSION = '0.130'; # Don't forget to set version and release
}  						# date in POD below!

use strict;
use warnings;
use Template;
use Carp;

# for debugging only
#use Data::Dumper;


=head1 NAME

  oVirtUI::Web - Create a webpage with Template Toolkit

=head1 SYNOPSIS

  use oVirtUI::Web;
  my $page	= BPView::oVirtUI->new(
             data_dir	=> '/var/www/bpview/static'
             );
  $page->display_page( page	=> 'results' );

=head1 DESCRIPTION

This module creates a webpage with Template Toolkit.

=head1 CONSTRUCTOR

=head2 new ( [ARGS] )

Creates an BPView::Web object. <new> takes at least the data_dir.
Arguments are in key-value pairs.
See L<EXAMPLES> for more complex variants.

=over 4

=item data_dir

path to oVirt-Monitoring UI-Plugin static directory

=item site_url

site url of ui-plugin (default: /ovirt-monitoring)

=item template

name of template to use (default: default)
Make sure to create a folder with this name in:
  $data_dir/css/
  $data_dir/images/
  $data_dir/src/
  
=item page

name of TT template for displaying webpage

=item content

additional content which shall be passed to TT 

=item component

pass name of component to webpage
(datacenter, cluster, storage, pool name)

=item refresh

refresh interval of webpage (default: 15000) [ms]

=item template_cache

use JS cache to cache templates (default: false)

=cut


sub new {
	
  my $invocant 	= shift;
  my $class 	= ref($invocant) || $invocant;
  my %options	= @_;
  
  my $self = {
  	"data_dir"			=> undef,			# static html directory
  	"site_url"			=> "/ovirt-monitoring",	# site url
  	"template"			=> "default",		# template to use
  	"page"				=> "results",		# page to display
  	"content"			=> undef,			# various content to pass to template toolkit
  	"component"			=> undef,			# name of component for display_page
  	"refresh"			=> 15000,			# refresh interval
  	"template_cache"	=> "false",			# cache templates
  };
  
  for my $key (keys %options){
  	if (exists $self->{ $key }){
  	  $self->{ $key } = $options{ $key };
  	}else{
  	  croak "Unknown option: $key";
  	}
  }
  
  # parameter validation
  croak "Missing data_dir!\n" if (! defined $self->{ 'data_dir' });
  
  bless $self, $class;
  
  # check if directories exist
  $self->_check_dir( $self->{ 'data_dir' } );
  
  return $self;
  
}


#----------------------------------------------------------------

=head1 METHODS	

=head2 display_page

 display_Page ( page => 'page_name' )

Creates a new webpage by using argument 'page' as Template Toolkit template name.

  $page->display_page( page	=> 'main' );

=cut


sub display_page {
	
  my $self		= shift;
  my %options	= @_;
  
  for my $key (keys %options){
  	if (exists $self->{ $key }){
  	  $self->{ $key } = $options{ $key };
  	}else{
  	  croak "Unknown option: $key";
  	}
  }
  
  # bring template_cache into right format
  if ($self->{ 'template_cache' } == 1){
  	$self->{ 'template_cache' } = "true";
  }elsif ($self->{ 'template_cache' } == 0){
  	$self->{ 'template_cache' } = "false";
  }
  
  # page to display ( e.g. results )
  my $tt_template	= $self->{ 'data_dir' } . "/src/" . $self->{ 'template' } . "/" . $self->{ 'page' } . ".tt";
  my $tt_vars		= { 
  	'templ' 		=> $self->{ 'template' },
  	'data_dir'		=> $self->{ 'data_dir' },
  	'site_url'		=> $self->{ 'site_url' }, 
  	'template_cache' 	=> $self->{ 'template_cache' },
  	'refresh_interval' 	=> $self->{ 'refresh' } * 1000,		# set refresh interval in ms
  };
  
  $tt_vars->{ 'content' } = $self->{ 'content' } if defined $self->{ 'content' };
  $tt_vars->{ 'comp' } = $self->{ 'component' } if defined $self->{ 'component' };
  
  # create new template
  my $template = Template->new({
  	ABSOLUTE		=> 1,
  	INCLUDE_PATH	=> [ $self->{ 'data_dir' } . "/src/" . $self->{ 'template' } ],
  	PRE_PROCESS		=> 'config',
  });
  
  # display page with template
  $template->process($tt_template, $tt_vars) || croak "Template process failed: " . $template->error();
  
}


#----------------------------------------------------------------

# internal methods
##################

# check if directory exists
sub _check_dir {
	
  my $self	= shift;
  my $dir	= shift or croak ("Missing directory!");
  
  croak "$dir - No such directory!" if ! $dir;
  
}

1;


=head1 EXAMPLES

Display results page of oVirt-Monitoring UI-Plugin with template default.

  use oVirtUI::Web;
  my $data_dir	= "/var/www/ovirt-monitoring/static";
  my $site_url	= "/ovirt-monitoring";
  my $template	= "default";
  
  my $page = oVirtUI::Web->new(
 	data_dir	=> $data_dir,
 	site_url	=> $site_url,
 	template	=> $template,
  );
  $page->display_page(
    page		=> "results",
  )
  

=head1 SEE ALSO

See oVirtUI::Config for reading and parsing configuration files.

=head1 AUTHOR

Rene Koch, E<lt>r.koch@ovido.atE<gt>

=head1 VERSION

Version 0.130  (August 15 2013))

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013 by René Koch <r.koch@ovido.at>

This library is free software; you can redistribute it and/or modify
it under the same terms as oVirt-Monitoring UI-Plugin itself.

=cut
