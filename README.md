# NAME

KDDart::DAL::wrapper - Perl wrapper for KDDart DAL RESTful API

# SYNOPSIS

    use KDDart::DAL::wrapper;
    my $DALobj = KDDart::DAL::wrapper->new( baseurl => 'http://dalserver.example.com/dal', %options );
    # with error checking
    if ($DALobj->error) {
      print $DALobj->errormsg . "\n";
      # maybe exit or something?
    }

# DESCRIPTION

This is a wrapper module allowing to easily log to DAL and perform operations in the service.

# EXPORT

None by default.

# DAL METHODS

## new

    my $DALobj = KDDart::DAL::wrapper->new( baseurl => 'http://dalserver.example.com/dal', %options );

Creates a DAL object to maintain during the session. The options are:

* baseurl         - Base DAL url, this is the only compulsory option to provide to the object

* format          - Data format DAL will return after any request. By default 'json', but can be 'xml' too

* extradata       - Flag \[0|1\], should the request return more data. By default '0'

* verbose         - Flag \[0|1\], print messages to STDOUT, not desirable in many cases like web applications. By default '0'

* dalcookies      - Hash ref to DAL cookies data

* cookiefolder    - Name of the folder where cookiefile will be stored. If not provided system tmp will be used

* cookiefile      - Name of the file where cookie will be stored. If not provided that random will be generated

* loginexpire     - 'no' by default, set to 'yes' if needed

* autogroupswitch - Flag \[0|1\], should user after login get first available group from groups it belongs to. By default '1'

If you have a previous session stored in a cookie file (in a cookie folder), than just build an object with relevant options to recover previous session and if it has not expired yet, application can continue from where it was before.

### Setter options

    $DALobj->format('xml'); # to change output format to xml

### Getter options

    my $current_format = $DALobj->format;  # what is the current format

### DAL cookies data format

After you login you can get DAL cookies data as a hashref:

    my $dalcookies = $DALobj->dalcookies;

They will be in a format:

    $dalcookies = {
      cookiename => {
        value   => 'cookievalue',
        path    => 'cookiepath',
        domain  => 'cookiedomain',
        expires => 'expiretime',
      }, ...
    }

### Session info

    $DALobj->writetoken           - STRING - will store write token after login
    $DALobj->username             - STRING - who is logged in
    $DALobj->userid               - INT - user numeric id (if not logged in -1)
    $DALobj->groupname            - STRING - current group name
    $DALobj->groupid              - INT - current group id (if no group selected yet -1)
    $DALobj->isgroupman           - FLAG \[0|1\] - if current user is group manager/owner
    $DALobj->groupselectionstatus - FLAG \[0|1\] - if group selected
    $DALobj->dalversion           - VERSION - dal version
    $DALobj->islogin              - FLAG \[0|1\] - login status

## DALlogin

    my ($content, $writetoken) = $DALobj->DALlogin( username => $username, password => $password, passwordcleartext => [0|1] );

Use this method to login to DAL. If you were successfully logged in, you need to follow with a SwitchGroup call to make most operations within DAL.

## SwitchGroup

    $DALobj->SwitchGroup(groupid => $groupid);

Subscribe user to the group, so now all DAL call become available. User will act as a member of this group obtaining privileges to data assigned to the group of choice and possibly administrative privileges if within selected group the user is it's manager

## DALlogout

    $DALobj->DALlogout();

Attempt to logout user from the system and destroy DAL session (empty cookie hash)

## DALgetContent

    my $content = $DALobj->DALgetContent( dalurl => 'list/site/20/page/1' );

Making a simple GET request to DAL. Format your url (with parameters if needed) and provide to this call

## DALpostContent

    my $content = $DALobj->DALpostContent(
      dalurl         => 'list/organisation/20/page/1',   # Required. No defaults
      nosign         => 1,                               # Optional. Default: 0
      upcontentform  => [m|f],                           # Optional. Only if uploading. m for memory and f for file upload
      upload         => $FileContentAsScalar,            # Required if upcontentform = m. Scalar with memory content to upload
      uploadfilename => $PathName,                       # Required if upcontentform = f. Path and file name to upload.
      params         => {                                # Optional. List of parameters and values to submit in request
        FieldList => 'OrganisationId',
        Filtering => 'OrganisationId > 0'
      }
    );

Making a POST request to DAL. Provide your url and hashref with parameters - if needed.

By default signature for data operations (like add, update, delete) will be calculated, but if your POST does not require any write operations or file upload you can set nosign to 1 (or something else which evaluates to true)

Do not set nosign to true if you want to upload file or memory content

# HELPER METHODS

## xml2data

    my $hash_ref = $self->xml2data( datasource => $content, tagname => 'WriteToken' );

Converts xml response into Perl data structures

## json2data

    my $hash_ref = $self->json2data( datasource => $content, tagname => 'WriteToken' );

Converts json response into Perl data structures

## content2data

    my $hash_ref = $self->content2data( datasource => $content, tagname => 'WriteToken' );

Converts DAL response into Perl data structures using current setting for the format. Internally will use either xml2data or json2data.

# Session Data

    $DALobj->writetoken;    # stores write token after login, empty string otherwise
    $DALobj->username;      # username who is logged in, empty string otherwise
    $DALobj->userid;        # user numeric id, -1 if not set
    $DALobj->groupname;     # current group name after switch group, empty string otherwise
    $DALobj->groupid;       # current group id, -1 if not set
    $DALobj->isgroupman;    # flag if current user is group manager/owner, only relevant after switch group
    $DALobj->dalversion;    # dal version, 0 if not yet set
    $DALobj->islogin;       # flag if user is logged in
    $DALobj->dalcookies;    # hashref with DAL session cookies. Same what is stored in your cookie file, but handy for setting in the browser

# SEE ALSO

DAL API documentation (http://www.kddart.org)

# AUTHOR

Grzegorz Uszynski, Diversity Arrays Technology Pty Ltd

# COPYRIGHT AND LICENSE

Copyright (C) 2015 by Diversity Arrays Technology Pty Ltd

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

