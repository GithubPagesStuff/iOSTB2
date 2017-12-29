//
//  QiLin Jailbreak ToolKit
//
//  Created by JL on 12/7/17.
//  Copyright © 2017 NewOSXBook. All rights reserved.
//
// Free to use, but please respect LICENSE
//

#ifndef qilin_h
#define qilin_h
#include <mach/mach.h>
#include <unistd.h>
#include <stdlib.h>


char *getMachine (void);
char *getOSVer(void);


// MUST call this first

int initQiLin (mach_port_t TFP0, uint64_t KernelBase);

// System wide effects
//
int remountRootFS (void);
int execCommand(char *Cmd, char *Arg1, char *Arg2, char *Arg3, char *Arg4, char *Arg5);
int moveFileFromAppDir (char *File, char *Dest);
int unpackBinariesToPath (char *BinPack,  char *Path, char *Unpacker);
int disableAutoUpdates(void);

// Code signing

int castrateAmfid (void);

// Utility function - you probably won't need this directly.
#define ALGORITHM_SHA256    1
char *cdHashOfFile(char *fileName,int Algorithm); // Calculate CDHash of a given Mach-O (for messing with AMFI)



// Kernel Memory access (wrappers over kernel_task send right)
uint64_t findKernelSymbol (char *Symbol);
void setKernelSymbol (char *Symbol, uint64_t Address);

int readKernelMemory(uint64_t Address, uint64_t Len, void **To);
int writeKernelMemory(uint64_t Address, uint64_t Len, void *From);

// Not recommended, but doable: Bestow task port of Pid in TargetPid
mach_port_t task_for_pid_in_kernel (pid_t Pid, pid_t TargetPid);

// Process manipulation functions
int setCSFlagsForProcAtAddr(uint64_t ProcStructAddr, int Flags, int Set);

int setCSFlagsForPid (pid_t Whom);
int platformizePid(pid_t Whom);
int rootifyPid(pid_t Whom);
int ShaiHuludPid (pid_t Whom);
int unShaiHuludPid (pid_t Whom);

// Presently, limited to two entitlements, and assumed boolean (true)
int entitlePid (pid_t Whom, char *Ent1, char *Ent2);

// Convenience functions - do all the above , but on my process

int platformizeMe (void);
int rootifyMe(void);

// Escape sandbox:
// call with 0 to assume kernel cred, else specify value
uint64_t ShaiHuludMe(uint64_t);
void unShaiHuludMe(uint64_t OrigCreds);
int entitleMe(char *entitlementString);
pid_t getPidForProcessName (char *ProcName);


/// Launchd handling utilities - just for you @launchderp :-)
int makeLaunchdPlist (char *PlistName, char *Program, char *ProgramArguments, char *StandardOutputPath, char *StandardErrorPath, int RunAtLoad);
int launjctlLaunchdPlist(char *Name);

// I use these internally, not sure anyone else would need them
int launjctlPrintSystem (void);
int launjctlDumpState(void);


// This one is still in progress.
int spawnJailbreakServer (void);


// UI Support:
// Provide status, error and debug print outs to user,
// which may be redirected to GUI views, etc.
// Default implmenentations are NSLog.

typedef void (status_func) (char *,...);
void setStatusFunction (status_func *Func);
void setErrorHandler (status_func *Func);
void setDebugHandler (status_func *Func);


// Utility functions you probably won't need unless you want to do your own debugging
void hexDump(void *Mem, int Len, uint64_t Addr);
void dumpARMThreadState64(_STRUCT_ARM_THREAD_STATE64 *old_state);

// Even more Internal/advanced use:
uint64_t findKernelTask (uint64_t InitialTask);
uint64_t findMyProcStructInKernelMemory(void);  // For other advanced uses I haven't provided already



#endif /* qilin_h */
