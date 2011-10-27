# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use strict;
use warnings;

package Clownfish::Method;
use base qw( Clownfish::Function );
use Clownfish::Util qw( verify_args );
use Carp;

my %new_PARAMS = (
    return_type => undef,
    class_name  => undef,
    class_cnick => undef,
    param_list  => undef,
    macro_sym   => undef,
    docucomment => undef,
    parcel      => undef,
    abstract    => undef,
    final       => undef,
    exposure    => 'parcel',
);

sub new {
    my ( $either, %args ) = @_;
    verify_args( \%new_PARAMS, %args ) or confess $@;
    $args{abstract} ||= 0;
    $args{parcel} = Clownfish::Parcel->acquire( $args{parcel} );
    $args{final} ||= 0;
    my $package = ref($either) || $either;
    return $package->_new(
        @args{
            qw( parcel exposure class_name class_cnick macro_sym
                return_type param_list docucomment final abstract )
            }
    );
}

1;

__END__

__POD__

=head1 NAME

Clownfish::Method - Metadata describing an instance method.

=head1 DESCRIPTION

Clownfish::Method is a specialized subclass of Clownfish::Function, with
the first argument required to be an Obj.

When compiling Clownfish code to C, Method objects generate all the code
that Function objects do, but also create symbols for indirect invocation via
VTable.

=head1 METHODS

=head2 new

    my $type = Clownfish::Method->new(
        parcel      => 'Crustacean',                       # default: special
        class_name  => 'Crustacean::Lobster::LobsterClaw', # required
        class_cnick => 'LobClaw',                          # default: special
        macro_sym   => 'Pinch',                            # required
        return_type => $void_type,                         # required
        param_list  => $param_list,                        # required
        exposure    => undef,                              # default: 'parcel'
        docucomment => $docucomment,                       # default: undef
        abstract    => undef,                              # default: undef
        final       => 1,                                  # default: undef
    );

=over

=item * B<param_list> - A Clownfish::ParamList.  The first element must be an
object of the class identified by C<class_name>.

=item * B<macro_sym> - The mixed case name which will be used when invoking the
method.

=item * B<abstract> - Indicate whether the method is abstract.

=item * B<final> - Indicate whether the method is final.

=item * B<parcel>, B<class_name>, B<class_cnick>, B<return_type>,
B<docucomment>, - see L<Clownfish::Function>.

=back

=head2 abstract final get_macro_sym 

Getters.

=head2 novel

Returns true if the method's class is the first in the inheritance hierarchy
in which the method was declared -- i.e. the method is neither inherited nor
overridden.

=head2 self_type

Return the L<Clownfish::Type> for C<self>.

=head2 short_method_sym

    # e.g. "LobClaw_Pinch"
    my $short_sym = $method->short_method_sym("LobClaw");

Returns the symbol used to invoke the method (minus the parcel Prefix).

=head2 full_method_sym

    # e.g. "Crust_LobClaw_Pinch"
    my $full_sym = $method->full_method_sym("LobClaw");

Returns the fully-qualified symbol used to invoke the method.

=head2 full_offset_sym

    # e.g. "Crust_LobClaw_Pinch_OFFSET"
    my $offset_sym = $method->full_offset_sym("LobClaw");

Returns the fully qualified name of the variable which stores the method's
vtable offset.

=head2 full_callback_sym

    # e.g. "crust_LobClaw_pinch_CALLBACK"
    my $callback_sym = $method->full_calback_sym("LobClaw");

Returns the fully qualified name of the variable which stores the method's
Callback object.

=head2 full_override_sym

    # e.g. "crust_LobClaw_pinch_OVERRIDE"
    my $override_func_sym = $method->full_override_sym("LobClaw");

Returns the fully qualified name of the function which implements the callback
to the host in the event that a host method has been defined which overrides
this method.

=head2 short_typedef

    # e.g. "Claw_pinch_t"
    my $short_typedef = $method->short_typedef;

Returns the typedef symbol for this method, which is derived from the class
nick of the first class in which the method was declared.

=head2 full_typedef

    # e.g. "crust_Claw_pinch_t"
    my $full_typedef = $method->full_typedef;

Returns the fully-qualified typedef symbol including parcel prefix.

=head2 override

    $method->override($method_being_overridden);

Let the Method know that it is overriding a method which was defined in a
parent class, and verify that the override is valid.

All methods start out believing that they are "novel", because we don't know
about inheritance until we build the hierarchy after all files have been
parsed.  override() is a way of going back and relabeling a method as
overridden when new information has become available: in this case, that a
parent class has defined a method with the same name.

=head2 finalize

    my $final_method = $method->finalize;

As with override, above, this is for going back and changing the nature of a
Method after new information has become available -- typically, when we
discover that the method has been inherited by a "final" class.

However, we don't modify the original Method as with override().  Inherited
Method objects are shared between parent and child classes; if a shared Method
object were to become final, it would interfere with its own inheritance.  So,
we make a copy, slightly modified to indicate that it is "final".

=head2 compatible

    confess("Can't override") unless $method->compatible($other);

Returns true if the methods have signatures and attributes which allow
one to override the other.

=cut
