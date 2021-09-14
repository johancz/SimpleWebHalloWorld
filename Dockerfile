FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build-env
WORKDIR /app

# copy csproj and restore and distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "SimpleWebHalloWorld.dll"]
