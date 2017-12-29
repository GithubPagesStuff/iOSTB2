//
//  ViewController.m
//  iOSTB
//
//  Created by Doc Aiden on 12/16/17.
//  Copyright © 2017 iDoc. All rights reserved.
//
#import <spawn.h>
#include <copyfile.h>
#include "fun.h"
#import "ViewController.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <dlfcn.h>
#include "async_wake.h"
#import <CoreFoundation/CoreFoundation.h>
#import "NSTask.h"
#import "qilin.h"
#include "Terminal/VT100Screen.h"
#include "Terminal/VT100Terminal.h"
#import "Terminal/SubProcess.h"

NSArray *nameArr;

int execprog(const char *prog, const char* args[]) {
    int rv;
    
    if (args == NULL) {
        args = (const char **)&(const char*[]){ prog, NULL };
    }
    
    const char *logfile = [NSString stringWithFormat:@"/tmp/%@-%lu",
                           [[NSMutableString stringWithUTF8String:prog] stringByReplacingOccurrencesOfString:@"/" withString:@"_"],
                           time(NULL)].UTF8String;
    printf("Spawning '%s' with [", prog);
    for(const char **arg = args; *arg != NULL; ++arg) {
        printf("'%s' ", *arg);
    }
    printf("] to file %s\n", logfile);
    
    posix_spawn_file_actions_t child_fd_actions;
    if ((rv = posix_spawn_file_actions_init (&child_fd_actions))) {
        perror ("posix_spawn_file_actions_init");
        return rv;
    }
    if ((rv = posix_spawn_file_actions_addopen (&child_fd_actions, STDOUT_FILENO, logfile,
                                                O_WRONLY | O_CREAT | O_TRUNC, 0666))) {
        perror ("posix_spawn_file_actions_addopen");
        return rv;
    }
    if ((rv = posix_spawn_file_actions_adddup2 (&child_fd_actions, STDOUT_FILENO, STDERR_FILENO))) {
        perror ("posix_spawn_file_actions_adddup2");
        return rv;
    }
    
    pid_t pd;
    if ((rv = posix_spawn(&pd, prog, &child_fd_actions, NULL, (char**)args, NULL))) {
        printf("posix_spawn error: %d (%s)", rv, strerror(rv));
        return rv;
    }
    
    int status;
    waitpid(pd, &status, 0);
    printf("'%s' exited with %d (sig %d)\n", prog, WEXITSTATUS(status), WTERMSIG(status));
    
    char buf[65] = {0};
    int fd = open(logfile, O_RDONLY);
    if (fd == -1) {
        perror("open logfile");
        return 1;
    }
    
    printf("contents of %s: \n ------------------------- \n", logfile);
    while(read(fd, buf, sizeof(buf) - 1) == sizeof(buf) - 1) {
        printf("%s", buf);
    }
    printf("%s", buf);
    printf("\n-------------------------\n");
    
    close(fd);
    remove(logfile);
    
    return 0;
}

NSArray* NSLS(NSString *path) {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
}

const char* pathRelativeToDocuments(const char *path) {
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [url.path stringByAppendingPathComponent:[NSString stringWithUTF8String:path]].UTF8String;
}
@interface ViewController ()

@end

@implementation ViewController
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    // Do any additional setup after loading the view, typically from a nib.
//    NSArray* nameArr = [NSArray arrayWithObjects: @"K", @"b", @"y", @"g",
//                        @"x", @"f", @"a", @"0",
//                        @"l", @"O", @"V", @"T", @"Z",
//                        @"S", @"M", @"H", @"N", @"J",
//                    @"r",@"u",@"i",@"e",@"w",@"c",@"d",@"q",@"p", nil];
//}
//NSArray* nameArr2 = [NSArray arrayWithObjects: @"I", @"b", @"y", @"g",
//                    @"x", @"f", @"a", @"0",
//                    @"l", @"O", @"V", @"T", @"Z",
//                    @"S", @"M", @"H", @"N", @"J",
//                    @"r",@"u",@"i",@"e",@"w",@"c",@"d",@"q",@"p", nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)RunCM:(id)sender {
    NSString* bash = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bash"];
    const char* bash_path2 = [bash UTF8String];
    copyfile(bash_path2, "/bin/bash", 0, COPYFILE_ALL);
    
    chmod("/bin/bash", 0777);
    
    NSBundle* bundleid;
    _cmdtxt = _commandInput.text;
    bundleid = [NSBundle mainBundle];
    NSString *command = [_mainBundle stringByAppendingString:@"/bash"];
//    go();
//
    mach_port_t user_client;
    mach_port_t tfp0 = get_tfp0(&user_client);
    let_the_fun_begin(tfp0, user_client);
    
    uid_t olduid = getuid();
//
    initQiLin(tfp0, find_kernel_base());
    castrateAmfid();
    
//    get_root();
    if (getuid() == 0) {
        NSLog(@"UID0 WORKED!");
        BOOL ile = true;
    }
    NSString *execPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bash"];
    const char *con2String = [execPath cStringUsingEncoding:NSASCIIStringEncoding];
//    const char *con5String = [_trustslist.text cStringUsingEncoding:NSASCIIStringEncoding];'
    const char *conString = [command cStringUsingEncoding:NSASCIIStringEncoding];
    const char *con3String = [@"/bin/bash" cStringUsingEncoding:NSASCIIStringEncoding];
//    const char* Title[] = { "-c", conString };
    _cmdtxt =  command;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:_commandInput.text]){
//        if (![fileManager fileExistsAtPath:@"/bin/bash"]) {
//            NSString* bash = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bash"];
//            const char* bash_path = [bash UTF8String];
//
//            unlink("/bin/bash");
//
//            copyfile(bash_path, "/bin/bash", 0, COPYFILE_ALL);
//            _outputShell.text = @"Bash Shell has been installed by the application. Please run the command again for it to ";
//        } else {
        
        
        NSData *data;
        NSTask *task = [[NSTask alloc] init];
        NSPipe *pipe = [[NSPipe alloc] init];
        NSLog(@"%@", _cmdtxt);
//              NSString* tar = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tar"];
//        NSString* bash2 = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bootstrap.tar"];
//            const char* bash_path = [tar UTF8String];
//             copyfile(bash_path, "/bin/tar", 0, COPYFILE_ALL);
//            chmod("/bin/tar", 0777);
//
//
//
//
//        mkdir("/exploit/", 0777);
        [task setLaunchPath:_commandInput.text];
        NSLog(_cmdarg.text);
 [task setArguments:@[_cmdarg.text]];
 [task setStandardError:pipe];
        [task setStandardOutput:pipe];
            NSLog(bash);
        [task launch];
        data = [[pipe fileHandleForReading] readDataToEndOfFile];
        NSString *outputtxt = [[NSString alloc] initWithData: data encoding:
                               NSASCIIStringEncoding];
        _outputShell.text = outputtxt;
        
        
        //    FILE *fp;
        //    char path[1035];
        //    fp = popen(conString,"r");
        //    setuid(olduid);
        //    while (fgets(path, sizeof(path), fp) != NULL) {
        //        printf("%s", path);
        //    }
        //    pclose(fp);
        setuid(olduid);
        
        //    execprog(con2String, Title);
        setuid(olduid);
        
        //    NSTask *task = [[NSTask alloc] init];
        //    [task setLaunchPath:@"bash"];
        //    [task setArguments:@[@"-c", @"/bin/df"]];
        //    [task launch];
        //
        
        setuid(olduid);
    } else {

        _outputShell.text = @"Sorry. This binary can NOT be found. :(";
    }
    
}
- (IBAction)TrustMe:(id)sender {
    
    {
        
        printf("hi");
    }
}


//////- (IBAction)RunCMD:(id)sender {
//
//
//
//
//
//
//
//    NSTask *task = [[NSTask alloc] init];
//    [task setLaunchPath:execPath];
//    [task setArguments:@[@"-c", @"/bin/df"]];
//    [task launch];
//
//
//    setuid(olduid);
//
////}


@end



