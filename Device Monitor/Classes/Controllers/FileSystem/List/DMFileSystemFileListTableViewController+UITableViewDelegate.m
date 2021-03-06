/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina - www.xs-labs.com
 * Distributed under the Boost Software License, Version 1.0.
 * 
 * Boost Software License - Version 1.0 - August 17th, 2003
 * 
 * Permission is hereby granted, free of charge, to any person or organization
 * obtaining a copy of the software and accompanying documentation covered by
 * this license (the "Software") to use, reproduce, display, distribute,
 * execute, and transmit the Software, and to prepare derivative works of the
 * Software, and to permit third-parties to whom the Software is furnished to
 * do so, all subject to the following:
 * 
 * The copyright notices in the Software and this entire statement, including
 * the above license grant, this restriction and the following disclaimer,
 * must be included in all copies of the Software, in whole or in part, and
 * all derivative works of the Software, unless such copies or derivative
 * works are solely in the form of machine-executable object code generated by
 * a source language processor.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
 * SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
 * FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        ...
 * @copyright   (c) 2012 - Jean-David Gadina - www.xs-labs.com
 * @abstract    ...
 */

#import "DMFileSystemFileListTableViewController+UITableViewDelegate.h"
#import "DMFileSystemFileListTableViewCell.h"
#import "DMFile.h"
#import "DMFileSystemTextViewController.h"
#import "DMFileSystemImageViewController.h"
#import "DMFileSystemAVViewController.h"
#import "DMFileSystemFileInfosViewController.h"
#import "DMFileSystemFileInfosViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation DMFileSystemFileListTableViewController( UITableViewDelegate )

- ( void )tableView: ( UITableView * )tableView didSelectRowAtIndexPath: ( NSIndexPath * )indexPath
{
    DMFileSystemFileListTableViewCell * cell;
    UIViewController                  * controller;
    DMFile                            * file;
    UIAlertView                       * alert;
    
    cell       = ( DMFileSystemFileListTableViewCell * )[ tableView cellForRowAtIndexPath: indexPath ];
    controller = nil;
    file       = ( cell.file.targetFile == nil ) ? cell.file : cell.file.targetFile;
    
    [ NSThread detachNewThreadSelector: @selector( startAnimating ) toTarget: cell withObject: nil ];
    [ tableView deselectRowAtIndexPath: indexPath animated: YES ];
    
    if( file.isReadable == YES && file.isDirectory == YES )
    {
        controller = [ [ DMFileSystemFileListTableViewController alloc ] initWithFile: file ];
    }
    else if( file.isReadable == YES )
    {
        if( file.isImage == YES )
        {
            controller = [ [ DMFileSystemImageViewController alloc ] initWithFile: file ];
        }
        else if( file.isAudio == YES || file.isVideo == YES )
        {
            controller = [ [ DMFileSystemAVViewController alloc ] initWithFile: file ];
        }
        else
        {
            controller = [ [ DMFileSystemTextViewController alloc ] initWithFile: file ];
        }
    }
    else if( file != nil )
    {
        controller = [ [ DMFileSystemFileInfosViewController alloc ] initWithFile: file ];
    }
    else
    {
        alert = [ [ UIAlertView alloc ] initWithTitle: NSLocalizedString( @"ProtectedFileAlertTitle", @"ProtectedFileAlertTitle" ) message: NSLocalizedString( @"ProtectedFileAlertText", @"ProtectedFileAlertText" ) delegate: nil cancelButtonTitle: NSLocalizedString( @"OK", @"OK" ) otherButtonTitles: nil ];
        
        [ alert show ];
        [ alert autorelease ];
    }
    
    if( controller != nil )
    {
        if( [ controller isKindOfClass: [ MPMoviePlayerViewController class ] ] )
        {
            [ self.navigationController presentMoviePlayerViewControllerAnimated: ( MPMoviePlayerViewController * )controller ];
        }
        else
        {
            [ self.navigationController pushViewController: controller animated: YES ];
        }
    }
    
    [ controller release ];
}

- ( void )tableView: ( UITableView * )tableView accessoryButtonTappedForRowWithIndexPath: ( NSIndexPath * )indexPath
{
    DMFileSystemFileListTableViewCell * cell;
    UIViewController                  * controller;
    DMFile                            * file;
    
    cell       = ( DMFileSystemFileListTableViewCell * )[ tableView cellForRowAtIndexPath: indexPath ];
    file       = ( cell.file.targetFile == nil ) ? cell.file : cell.file.targetFile;
    controller = [ [ DMFileSystemFileInfosViewController alloc ] initWithFile: file ];
    
    if( controller != nil )
    {
        [ self.navigationController pushViewController: controller animated: YES ];
    }
    
    [ controller release ];
}

@end
