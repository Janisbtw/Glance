#include <Foundation/Foundation.h>
#import <Orion/Orion.h>
#include <dlfcn.h>

__attribute__((constructor)) static void init() {
    // Initialize Orion - do not remove this line.
    orion_init();
    // Custom initialization code goes here.
}