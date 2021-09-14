# Specify that we want to base our image upon "dotnet sdk 3.1 image" in microsoft's container registry (MCR), and fetch it.
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build-env
# Set the working directory (i.e. the directory where we want our files and the directory in which commands (such as COPY, RUN and ENTRYPOINT) should be executed in)
WORKDIR /app

# Copy "SimpleWebHalloWorld.csproj" to our workdir and restore it in its own container layer.
COPY *.csproj ./
RUN dotnet restore

# Copy everything else to our workdir and build the project
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:3.1
# Set the working directory again.
WORKDIR /app
# Copy the built files to its own "out" directory.
COPY --from=build-env /app/out .
# Set the app's entry point by having docker invoke "dotnet SimpleWebHalloWorld.dll" in the command line.
ENTRYPOINT ["dotnet", "SimpleWebHalloWorld.dll"]
