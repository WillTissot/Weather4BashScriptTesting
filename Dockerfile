#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Weather4BashScript/Weather4BashScript.csproj", "Weather4BashScript/"]
RUN dotnet restore "Weather4BashScript/Weather4BashScript.csproj"
COPY . .
WORKDIR "/src/Weather4BashScript"
RUN dotnet build "Weather4BashScript.csproj" -c testVar -o /app/build

FROM build AS publish
RUN dotnet publish "Weather4BashScript.csproj" -c testVar -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Weather4BashScript.dll"]