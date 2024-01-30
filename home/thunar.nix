{ lib, user, hostname, ... }: {

  # Standard GTK3 Bookmarks
  gtk.gtk3.bookmarks = [
    #"file:///home/${user}/" # Toolbar Home button instead
    "file:///home/${user}/Desktop"
    "file:///home/${user}/Documents"
    "file:///home/${user}/Downloads"
    "file:///home/${user}/Videos"
    "file:///home/${user}/Pictures"
    "file:///home/${user}/dev"
    "file:///home/${user}/.config"
  ] ++ lib.optionals (hostname == "pc") [
    "file:///mnt/windows"
    "file:///mnt/SecondaryDrive"
    "file:///mnt/arch-home"
    "file:///mnt/arch-root"
  ];

  # Make thunar side panel a different color than the main panel
  gtk.gtk3.extraCss = ''
    .thunar .sidebar .view { background-color: @window_bg_color; }
  '';

  # Set default Thunar UI arrangement (and removes the annoying default bookmarks)
  xdg.configFile."xfce4/xfconf/xfce-perchannel-xml/thunar.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>

    <channel name="thunar" version="1.0">
      <property name="last-details-view-zoom-level" type="string" value="THUNAR_ZOOM_LEVEL_50_PERCENT"/>
      <property name="last-view" type="string" value="ThunarIconView"/>
      <property name="last-details-view-visible-columns" type="string" value="THUNAR_COLUMN_DATE_MODIFIED,THUNAR_COLUMN_NAME,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_TYPE"/>
      <property name="last-icon-view-zoom-level" type="string" value="THUNAR_ZOOM_LEVEL_100_PERCENT"/>
      <property name="last-window-maximized" type="bool" value="true"/>
      <property name="last-details-view-column-widths" type="string" value="109,120,113,50,80,80,65,112,348,185,102,72,106,193"/>
      <property name="last-separator-position" type="int" value="180"/>
      <property name="last-show-hidden" type="bool" value="true"/>
      <property name="last-menubar-visible" type="bool" value="true"/>
      <property name="last-statusbar-visible" type="bool" value="true"/>
      <property name="last-sort-column" type="string" value="THUNAR_COLUMN_NAME"/>
      <property name="last-sort-order" type="string" value="GTK_SORT_ASCENDING"/>
      <property name="last-toolbar-item-order" type="string" value="0,1,2,3,4,5,6,7,8,9,14,12,16,13,11,10,17,15"/>
      <property name="last-toolbar-visible-buttons" type="string" value="0,1,1,1,1,0,0,0,0,0,1,0,1,1,1,1,0,0"/>
      <property name="misc-single-click" type="bool" value="false"/>
      <property name="misc-exec-shell-scripts-by-default" type="bool" value="false"/>
      <property name="hidden-bookmarks" type="array">
        <value type="string" value="computer:///"/>
        <value type="string" value="file:///home/jack/Desktop"/>
        <value type="string" value="file:///home/jack"/>
      </property>
      <property name="misc-folder-item-count" type="string" value="THUNAR_FOLDER_ITEM_COUNT_ONLY_LOCAL"/>
      <property name="last-details-view-fixed-columns" type="bool" value="false"/>
      <property name="last-details-view-column-order" type="string" value="THUNAR_COLUMN_NAME,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_SIZE_IN_BYTES,THUNAR_COLUMN_TYPE,THUNAR_COLUMN_DATE_MODIFIED"/>
      <property name="misc-status-bar-active-info" type="uint" value="15"/>
      <property name="misc-recursive-permissions" type="string" value="THUNAR_RECURSIVE_PERMISSIONS_ASK"/>
    </channel>
  '';

  # Use kitty by default when opening a terminal
  xdg.configFile."Thunar/uca.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <actions>
    <action>
      <icon>utilities-terminal</icon>
      <name>Open Terminal Here</name>
      <submenu></submenu>
      <unique-id>1702940142376854-1</unique-id>
      <command>kitty -d %f</command>
      <description>Open Kitty Terminal Here</description>
      <range></range>
      <patterns>*</patterns>
      <startup-notify/>
      <directories/>
    </action>
    </actions>
  '';
}
