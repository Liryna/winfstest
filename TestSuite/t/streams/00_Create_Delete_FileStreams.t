#!/usr/bin/python

# CreateFile (file stream)
# DeleteFile (file stream)

from winfstest import *

name = uniqname()

expect("CreateFile %s:foo GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("CreateFile %s GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, "ERROR_FILE_EXISTS")
expect("CreateFile %s::$DATA GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, "ERROR_FILE_EXISTS")
expect("CreateFile %s:foo GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, "ERROR_FILE_EXISTS")
expect("CreateFile %s:foo:$DATA GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, "ERROR_FILE_EXISTS")
e, r = expect("GetFileInformation %s"% name, 0)
e, s = expect("GetFileInformation %s:foo"% name, 0)
testeval(r[0]["FileIndex"] == s[0]["FileIndex"])
expect("DeleteFile %s" % name, 0)
expect("DeleteFile %s:foo" % name, "ERROR_FILE_NOT_FOUND")
expect("DeleteFile %s" % name, "ERROR_FILE_NOT_FOUND")

expect("CreateFile %s GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("CreateFile %s GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, "ERROR_FILE_EXISTS")
expect("CreateFile %s:foo GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("CreateFile %s:foo GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, "ERROR_FILE_EXISTS")
e, r = expect("GetFileInformation %s"% name, 0)
e, s = expect("GetFileInformation %s:foo"% name, 0)
testeval(r[0]["FileIndex"] == s[0]["FileIndex"])
expect("DeleteFile %s:foo" % name, 0)
expect("DeleteFile %s:foo" % name, "ERROR_FILE_NOT_FOUND")
expect("DeleteFile %s" % name, 0)
expect("DeleteFile %s" % name, "ERROR_FILE_NOT_FOUND")

expect("CreateFile %s:foo:$DATA GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
e, r = expect("GetFileInformation %s"% name, 0)
e, s = expect("GetFileInformation %s:foo"% name, 0)
testeval(r[0]["FileIndex"] == s[0]["FileIndex"])
expect("DeleteFile %s" % name, 0)

expect("CreateFile %s:foo:$DATA GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("-e CreateFile %s:foo:$DATA GENERIC_WRITE 0 0 CREATE_ALWAYS FILE_ATTRIBUTE_NORMAL 0" % name, "ERROR_ALREADY_EXISTS")
e, r = expect("GetFileInformation %s"% name, 0)
e, s = expect("GetFileInformation %s:foo"% name, 0)
testeval(r[0]["FileIndex"] == s[0]["FileIndex"])
expect("DeleteFile %s" % name, 0)

# test sync file information between streams
expect("CreateFile %s:foo GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_HIDDEN 0" % name, 0)
e, r = expect("GetFileInformation %s"% name, 0)
e, s = expect("GetFileInformation %s:foo"% name, 0)
testeval(r[0] == s[0])
expect("CreateFile %s:foo GENERIC_WRITE 0 0 OPEN_EXISTING FILE_ATTRIBUTE_SYSTEM 0" % name, 0)
e, r = expect("GetFileInformation %s"% name, 0)
e, s = expect("GetFileInformation %s:foo"% name, 0)
testeval(r[0] == s[0])
expect("SetFileAttributes %s FILE_ATTRIBUTE_NORMAL" % name, 0)
e, r = expect("GetFileInformation %s"% name, 0)
e, s = expect("GetFileInformation %s:foo"% name, 0)
testeval(r[0] == s[0])
expect("SetFileTime %s 2134 2134-10-11T12:34:56 0" % name, 0)
e, r = expect("GetFileInformation %s"% name, 0)
e, s = expect("GetFileInformation %s:foo"% name, 0)
testeval(r[0] == s[0])
expect("DeleteFile %s" % name, 0)

# test creating streams with internal types
expect("CreateFile %s:foo GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, 0)
expect("CreateFile %s:foo:$EA GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, "ERROR_ACCESS_DENIED")
expect("CreateFile %s:bar:$EA GENERIC_WRITE 0 0 CREATE_NEW FILE_ATTRIBUTE_NORMAL 0" % name, "ERROR_ACCESS_DENIED")
expect("DeleteFile %s" % name, 0)

testdone()
