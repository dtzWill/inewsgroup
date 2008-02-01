//Will Dietz
//inewsgroup.m --wrapper/launcher for main application

/*
    This file is part of iNewsGroup.

    iNewsGroup is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    iNewsGroup is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with iNewsGroup.  If not, see <http://www.gnu.org/licenses/>.

*/

#import <UIKit/UIKit.h>
#import "consts.h"
#import "iNewsApp.h"
#import <pwd.h>

//run the main app!
int main(int argc, char **argv)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSLog( @"starting... \n" );	

	//make sure this directory exists!
	struct passwd * p = getpwuid( getuid() );
	char * home = p->pw_dir;

	char buffer[ MAX_FILENAME_LEN ];
	strncpy( buffer, home, MAX_FILENAME_LEN - 1 );
	strcat( buffer, TIN_DIR );

	mkdir( TIN_DIR, S_IRUSR | S_IWUSR | S_IXUSR | S_IRGRP | S_IWGRP | S_IXGRP ); 

	
	return UIApplicationMain(argc, argv, [iNewsApp class]);
}
