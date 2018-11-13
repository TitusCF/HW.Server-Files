#!/usr/bin/perl

require "util.pl";

$root = $ARGV[0];
$archetypes = "archetypes";

### main
&info ("examining $archetypes ...");

open (ARCH,"< $archetypes") || &die ("cannot open $archetypes");
&checkarch;
close (ARCH);

exit 0;


sub checkarch {
	$warnings = 0;
	$more = 0;
line:	while(<ARCH>) {
	    chop;
	    ($var,@values) = split;
	    if ($var eq "More") {
		$more = 1;
		next line;
	    }
	    if ($var eq "Object") {
		$arch = $values[0];
		$is_alive = 0;
		$level = 0;
                $type = 0;
                $move_apply = 0;
		$is_not_head = $more;
		$more = 0;
		next line;
	    }
	    $more = 0;
	    if ($var eq "end") {
		if ( ! $is_not_head && $is_alive && $level <= 0) {
		    &warn ("arch $arch is alive, but doesn't have level");
		    $warnings++;
		}
                if ($type == 61 && $level <= 0) {
                    &warn ("arch $arch is a FIRECHEST, but doesn't have level");
                    $warnings++;
                }
                if ($type == 62 && $level <= 0) {
                    &warn ("arch $arch is a FIREWALL, but doesn't have level");
                    $warnings++;
                }
                if ($type == 5 && $level <= 0) {
                    &warn ("arch $arch is a POTION, but doesn't have level");
                    $warnings++;
                }
                if ($move_apply && $type == 0) {
                    &warn ("arch $arch has walk/fly on/off but doesn't have a type");
                    $warnings++;
                }
		next line;
	    }
	    if ($var eq "alive") {
		$is_alive = $values[0];
		next line;
	    }
	    if ($var eq "level") {
		$level = $values[0];
		next line;
	    }
            if ($var eq "type") {
                $type = $values[0];
                next line;
            }
            if ($var eq "move_on" || $var eq "move_off")
            {
                $move_apply |= 1;
                next line;
            }
    }
    &info ("$warnings problems found");
}
