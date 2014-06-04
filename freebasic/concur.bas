'
' FreeBasic implementation
' To run on ubuntu:
'   $ sudo apt-get install gcc-multilib g++-multilib
'   $ sudo apt-get install lib32ncurses5-dev
'   $ sudo apt-get install libx11-dev:i386 libxext-dev:i386 libxrender-dev:i386 libxrandr-dev:i386 libxpm-dev:i386
' Download from: http://sourceforge.net/projects/fbc/files/Binaries%20-%20Linux/
'
Dim Shared results(3) As Integer
Dim Shared index As Integer
Dim Shared numbermutex As Any Ptr
Dim resultsthread As Any Ptr
Dim Shared condmutex As Any Ptr
Dim Shared cond As Any Ptr

index = 1
numbermutex = MutexCreate
condmutex = MutexCreate
cond = CondCreate

Sub saveresult (value as Integer)
    MutexLock numbermutex
    results(index) = value
    index = index + 1
    CondSignal cond
    MutexUnlock numbermutex
End Sub

Sub a (param As Any Ptr)    
    saveresult 2 * 10
End Sub

Sub b (param As Any Ptr)    
    saveresult 2 * 20
End Sub

Sub c (param As Any Ptr)    
    saveresult 30 + 40
End Sub

Sub getresults (param As Any Ptr)    
    MutexLock condmutex
    Do While index < 4
        CondWait cond, condmutex
    Loop
    Print results(1) ; " + " ; results(2) ; " + " ; results(3) ; " = " ; (results(1) + results(2) + results(3))
    MutexUnlock condmutex
End Sub

resultsthread = ThreadCreate( @getresults, 0 )
ThreadCreate( @a, 0 )
ThreadCreate( @b, 0 )
ThreadCreate( @c, 0 )

ThreadWait resultsthread
