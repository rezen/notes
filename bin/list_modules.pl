#!/usr/bin/perl

# cpan modules were installed say a year ago. If you
# cpan install that same module on another system it
# will be a different version. With cpanm/cpanfile 
# you can specify a version. This tool allows you
# to dump a cpanfile compatible formatted output of 
# the current environments module versions.
# 
# @example output
# requires 'Proc::Daemon', '== 0.14';
# 
# @usage 
# To see all modules with version
# ./list_modules.pl
#  
# To see a filtered down list
# ./list_modules.pl MongoDB,Beanstalkd,Dumper
# 
# @notes
# - use cpanminus! 
#   `curl -L https://cpanmin.us | perl - --sudo App::cpanminus`
#   `cpanm --installdeps .`
# - Another way to see installed modules perldoc perllocal

use strict;
use ExtUtils::Installed;

my @filtered = map {split(/,/, $_)} @ARGV;
my $filter_count = scalar @filtered;

my $inst    = ExtUtils::Installed->new();
my @modules = $inst->modules();
my %modules_map = map { $_ => 1 } @modules;

my $file = '';
my $files;
my $version;
my @matched = ();

sub add_module_info {
  my $module_name = shift;
  $version = $inst->version($module_name);
  push @matched, "requires '$module_name', '== $version';";
}

sub print_list {
  my $list_ref = shift;
  my @list = sort @{$list_ref};

  foreach my $match (@list) {
    print "$match\n";
  }
}

sub already_matched {
  my $module_name = shift;
  my @found = grep(/$module_name/, @matched);
  my $matched_x = scalar @found;
  return ($matched_x ne 0);
}

sub is_in_filter {
  my $module_name = shift;
  foreach my $filter (@filtered) {
    if (index($module_name, $filter) != -1) {
      return 1;
    }
  }

  return 0;
}

foreach my $module (@modules) {
  # Checking for filter matches
  if ($filter_count gt 0) {
    if (!is_in_filter($module)) {
      next;
    }
  }

  add_module_info($module);
}

# Checking for filter matches
if ($filter_count eq 0) {
  print_list(\@matched);
  exit 0;
}

my @missing = ();

# Post process and make sure to check each module 
# name explicitly provided
foreach my $filter (@filtered) {
  if (already_matched($filter)) {
    next;
  }

  my ($module_ns, $submodule) = split(/::/, $filter);

  if (already_matched($module_ns)) {
    next;
  }

  if(exists($modules_map{$module_ns})) {
    add_module_info($module_ns);
  } else {
    push @missing, "# Missing: requires '$filter', '== x.y.z';";
  }
}

print_list(\@matched);
print_list(\@missing);
exit 0;