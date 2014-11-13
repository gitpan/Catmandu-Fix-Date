requires 'perl','5.10.1';
requires 'Catmandu','0';
requires 'Moo','0';
requires 'DateTime','0';
requires 'DateTime::Format::Strptime','0';
requires 'DateTime::TimeZone','0';
requires 'Time::HiRes','0';

on 'test',sub {
    requires 'Test::More','0';
    requires 'Test::Exception','0';
};
