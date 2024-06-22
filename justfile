_build_playwright:
  #!/usr/bin/env bash
  set -euxo pipefail
  pushd scripts && npm install  && npx --yes playwright install && popd

run: build
  cd server && java -Xmx2G -Xms2G -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1HeapRegionSize=8M -XX:G1HeapWastePercent=5 -XX:G1MaxNewSizePercent=40 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1NewSizePercent=30 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15 -XX:MaxGCPauseMillis=200 -XX:MaxTenuringThreshold=1 -XX:SurvivorRatio=32 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paperclip.jar --nogui && cd -

wipe:
  rm -rf server/world

build: _build_playwright
  test -f server/plugins/ProtocolLib.jar || wget -nc -O server/plugins/ProtocolLib.jar https://ci.dmulloy2.net/job/ProtocolLib/lastSuccessfulBuild/artifact/build/libs/ProtocolLib.jar
  test -f server/plugins/EssentialsX.jar || wget -nc -O server/plugins/EssentialsX.jar https://ci.ender.zone/job/EssentialsX/lastSuccessfulBuild/artifact/jars/EssentialsX-2.21.0-dev+93-3a6fdd9.jar
  test -f server/plugins/LuckPerms.jar || wget -nc -O server/plugins/LuckPerms.jar https://download.luckperms.net/1549/bukkit/loader/LuckPerms-Bukkit-5.4.134.jar
  test -f server/plugins/WorldEdit.jar || wget -nc -O server/plugins/WorldEdit.jar https://cdn.modrinth.com/data/1u6JkXh5/versions/kZ0IykHx/worldedit-bukkit-7.3.3.jar
  test -f server/plugins/Vault.jar || node scripts/download.js '.project-file-download-container' https://dev.bukkit.org/projects/vault/files/3007470 server/plugins/Vault.jar
  mvn -DskipTests clean install && mv target/Lynx-1.0.0.jar server/plugins/Lynx.jar

# dependencies tree for compile
#dependencies:
#  mvn dependency:tree -Dscope=compile > dependencies.txt
#
## display updates
#updates:
#  mvn versions:display-dependency-updates > updates.txt