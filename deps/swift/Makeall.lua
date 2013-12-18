function getfiles(pat)
	local fid = io.popen("find . -name '" .. pat .. "'")
	local ret = {}
	for l in fid:lines() do
		ret[#ret+1] = l
	end
	return ret
end

local f = getfiles("*.f")

local fid = io.open("Makefile.sh", "w")
if not fid then error("Could not create Makefile.sh") end
os.execute("rm libswift.a")
os.execute("mkdir objects")
for i = 1, #f do
	if not (f[i]:find("main/") or f[i]:find("tools/") or f[i]:find("cpp_test/")) then
	local bname = f[i]:match("/([^/]-).f$")
	
	fid:write(string.format("echo \"$FORTRAN $FFLAGS %s -o objects/%s.o\"; $FORTRAN $FFLAGS %s -o objects/%s.o\n", f[i], bname, f[i], bname))
	end
end

fid:close()
os.execute("sh Makefile.sh")
