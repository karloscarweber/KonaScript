// kona_vm.c


// initVM()
// Initializes the VM byt getting memory, and setting defaults.
void initVM() {
	resetStack();
	vm.objects = NULL;
	vm.bytesAllocated = 0;
	vm.nextGC = 1024 * 1024;
	
	vm.grayCount = 0;
	vm.grayCapacity = 0;
	vm.grayStack = NULL;
	
	initTable(&vm.globals);
	initTable(&vm.strings);
	initTable(&vm.symbols);
	
	vm.initString = NULL;
	vm.initString = copyString("init", 4);
	
	defineNative("clock", clockNative);
}
