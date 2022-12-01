FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["dotnetapplication/dotnetapplication.csproj", "MyAppdotnetapplication/"]
RUN dotnet restore "dotnetapplication/dotnetapplication.csproj"
COPY . .
WORKDIR "/src/dotnetapplication"
RUN dotnet build "dotnetapplication.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "dotnetapplication.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "dotnetapplication.dll"]