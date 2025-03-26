using Profile
using PProf

function profile_main()
    @profile Template.main()
end

Profile.clear()
profile_main()
pprof()

