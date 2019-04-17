set number_signals [gtkwave::getNumFacs]
set signals  [list]
lappend signals "__bug_marker__" 
for {set i 0} {$i < $number_signals} {incr i} {
set name [ gtkwave::getFacName $i ]
lappend signals $name
}
set num_added [gtkwave::addSignalsFromList $signals]
