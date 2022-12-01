# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:6.0 as build-env
WORKDIR /app
EXPOSE 80
EXPOSE 5000
EXPOSE 443

# Copy csproj and restore as distinct layers
COPY dotnetapplication.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
WORKDIR /app
RUN dotnet publish "dotnetapplication.csproj" -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app
COPY --from=build-env /app/out ./
ENTRYPOINT ["dotnet", "dotnetapplication.dll"]