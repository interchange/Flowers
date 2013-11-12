use IC6::Schema;

@connection = ('dbi:Pg:database=jeff;host=localhost;port=5433','jeff','b00dylish');
$db = IC6::Schema->connect(@connection);

sub get_subs {
    my ($start, $n, $inp, $path, $p);
    $path = shift; $p = shift || [];

    open(INP, $path) || die;
    $inp = ' ' . join('', <INP>);
    close(INP);

    while ($inp =~ /[\n ]sub[\n ]/g) {
        $start = pos($inp) - 4;
        $n = 1; pos($inp) = index($inp, '{', pos($inp)) + 1;
        while ($inp =~ /(}|{)/g) {
            if ($1 eq '}') { if (!(--$n)) { last; } }
            else { $n++; }
        }
        push(@$p, substr($inp, $start, pos($inp) - $start));
    }
    return $p;
}

1;
