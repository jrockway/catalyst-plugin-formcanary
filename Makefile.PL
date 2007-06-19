use inc::Module::Install;

name 'Catalyst-Plugin-FormCanary';
all_from 'lib/Catalyst/Plugin/FormCanary.pm';

requires 'Catalyst::Plugin::Session';

build_requires 'Test::More';
build_requires 'Test::Exception';
build_requires 'ok';
build_requires 'Catalyst::Plugin::Session::Store::Dummy';
build_requires 'Catalyst::Plugin::Session::State::Cookie'; # mmm, cookies

auto_install;

WriteAll;

