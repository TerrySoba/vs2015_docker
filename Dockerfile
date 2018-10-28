# escape=`

FROM microsoft/windowsservercore:1803
# FROM microsoft/dotnet-framework:4.7.2-sdk-windowsservercore-1803

# Copy our Install script.
COPY Install.cmd C:\TEMP\

# Download collect.exe in case of an install failure.
ADD https://aka.ms/vscollect.exe C:\TEMP\collect.exe

# Use the latest release channel. For more control, specify the location of an internal layout.
ARG CHANNEL_URL=https://aka.ms/vs/15/release/channel
ADD ${CHANNEL_URL} C:\TEMP\VisualStudio.chman

# Download and install Build Tools excluding workloads and components with known issues.
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --channelUri C:\TEMP\VisualStudio.chman `
    --installChannelUri C:\TEMP\VisualStudio.chman `
    # --all `
    --add Microsoft.VisualStudio.Component.Static.Analysis.Tools `
    --add Microsoft.VisualStudio.Component.VC.CoreBuildTools `
    --add Microsoft.VisualStudio.Component.VC.Redist.14.Latest `
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
    --add Microsoft.VisualStudio.Component.Windows10SDK `
    --add Microsoft.VisualStudio.Component.TestTools.BuildTools `
    --add Microsoft.VisualStudio.Component.VC.CMake.Project `
    --add Microsoft.VisualStudio.Component.VC.140 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 `
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 `
    --remove Microsoft.VisualStudio.Component.Windows81SDK

# Start developer command prompt with any other commands specified.
# ENTRYPOINT C:\BuildTools\Common7\Tools\VsDevCmd.bat &&

SHELL ["cmd", "/S", "/C"]

#ADD cmake-3.12.1-win64-x64.tar.gz .
#ADD jre-8u181-windows-x64.tar.gz .
#ADD ninja.exe .
#RUN setx path "C:\\cmake-3.12.1-win64-x64\\bin;C:\\jre1.8.0_181\\bin;%PATH%"

#COPY main.cpp .
#COPY CMakeLists.txt .
#COPY build.bat .

# ENTRYPOINT C:\BuildTools\VC\Auxiliary\Build\vcvarsall.bat x86 -vcvars_ver=14.0 &&

# Default to PowerShell if no other command specified.
# CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
