# frozen_string_literal: true

require 'set'

class DeviceDetector
  class OS < Parser
    def name
      os_info[:name]
    end

    def short_name
      os_info[:short]
    end

    def family
      os_info[:family]
    end

    def desktop?
      DESKTOP_OSS.include?(family)
    end

    def full_version
      raw_version = super.to_s.split('_').join('.')
      raw_version == '' ? nil : raw_version
    end

    private

    def os_info
      from_cache(['os_info', self.class.name, user_agent]) do
        os_name = NameExtractor.new(user_agent, regex_meta).call
        if os_name && (short = DOWNCASED_OPERATING_SYSTEMS[os_name.downcase])
          os_name = OPERATING_SYSTEMS[short]
        else
          short = 'UNK'
        end
        { name: os_name, short: short, family: FAMILY_TO_OS[short] }
      end
    end

    DESKTOP_OSS = Set.new(
      [
        'AmigaOS', 'IBM', 'GNU/Linux', 'Mac', 'Unix', 'Windows', 'BeOS', 'Chrome OS'
      ]
    )

    # OS short codes mapped to long names
    OPERATING_SYSTEMS = {
      'AIX' => 'AIX',
      'AND' => 'Android',
      'AMG' => 'AmigaOS',
      'ATV' => 'tvOS',
      'ARL' => 'Arch Linux',
      'BTR' => 'BackTrack',
      'SBA' => 'Bada',
      'BEO' => 'BeOS',
      'BLB' => 'BlackBerry OS',
      'QNX' => 'BlackBerry Tablet OS',
      'BMP' => 'Brew',
      'CAI' => 'Caixa Mágica',
      'CES' => 'CentOS',
      'COS' => 'Chrome OS',
      'CYN' => 'CyanogenMod',
      'DEB' => 'Debian',
      'DEE' => 'Deepin',
      'DFB' => 'DragonFly',
      'DVK' => 'DVKBuntu',
      'FED' => 'Fedora',
      'FEN' => 'Fenix',
      'FOS' => 'Firefox OS',
      'FIR' => 'Fire OS',
      'FRE' => 'Freebox',
      'BSD' => 'FreeBSD',
      'FYD' => 'FydeOS',
      'GNT' => 'Gentoo',
      'GRI' => 'GridOS',
      'GTV' => 'Google TV',
      'HPX' => 'HP-UX',
      'HAI' => 'Haiku OS',
      'IPA' => 'iPadOS',
      'HAR' => 'HarmonyOS',
      'HAS' => 'HasCodingOS',
      'IRI' => 'IRIX',
      'INF' => 'Inferno',
      'JME' => 'Java ME',
      'KOS' => 'KaiOS',
      'KNO' => 'Knoppix',
      'KBT' => 'Kubuntu',
      'LIN' => 'GNU/Linux',
      'LBT' => 'Lubuntu',
      'LOS' => 'Lumin OS',
      'VLN' => 'VectorLinux',
      'MAC' => 'Mac',
      'MAE' => 'Maemo',
      'MAG' => 'Mageia',
      'MDR' => 'Mandriva',
      'SMG' => 'MeeGo',
      'MCD' => 'MocorDroid',
      'MIN' => 'Mint',
      'MLD' => 'MildWild',
      'MOR' => 'MorphOS',
      'NBS' => 'NetBSD',
      'MTK' => 'MTK / Nucleus',
      'MRE' => 'MRE',
      'WII' => 'Nintendo',
      'NDS' => 'Nintendo Mobile',
      'OS2' => 'OS/2',
      'T64' => 'OSF1',
      'OBS' => 'OpenBSD',
      'ORD' => 'Ordissimo',
      'PCL' => 'PCLinuxOS',
      'PSP' => 'PlayStation Portable',
      'PS3' => 'PlayStation',
      'RHT' => 'Red Hat',
      'ROS' => 'RISC OS',
      'RSO' => 'Rosa',
      'REM' => 'Remix OS',
      'REX' => 'REX',
      'RZD' => 'RazoDroiD',
      'SAB' => 'Sabayon',
      'SSE' => 'SUSE',
      'SAF' => 'Sailfish OS',
      'SEE' => 'SeewoOS',
      'SLW' => 'Slackware',
      'SOS' => 'Solaris',
      'SYL' => 'Syllable',
      'SYM' => 'Symbian',
      'SYS' => 'Symbian OS',
      'S40' => 'Symbian OS Series 40',
      'S60' => 'Symbian OS Series 60',
      'SY3' => 'Symbian^3',
      'TDX' => 'ThreadX',
      'TIZ' => 'Tizen',
      'TOS' => 'TmaxOS',
      'UBT' => 'Ubuntu',
      'WAS' => 'watchOS',
      'WTV' => 'WebTV',
      'WHS' => 'Whale OS',
      'WIN' => 'Windows',
      'WCE' => 'Windows CE',
      'WIO' => 'Windows IoT',
      'WMO' => 'Windows Mobile',
      'WPH' => 'Windows Phone',
      'WRT' => 'Windows RT',
      'XBX' => 'Xbox',
      'XBT' => 'Xubuntu',
      'YNS' => 'YunOs',
      'IOS' => 'iOS',
      'POS' => 'palmOS',
      'WOS' => 'webOS'
    }.freeze

    DOWNCASED_OPERATING_SYSTEMS = OPERATING_SYSTEMS.each_with_object({}) do |(short, long), h|
      h[long.downcase] = short
    end.freeze

    OS_FAMILIES = {
      'Android' => %w[AND CYN FIR REM RZD MLD MCD YNS GRI HAR],
      'AmigaOS' => %w[AMG MOR],
      'BlackBerry' => %w[BLB QNX],
      'Brew' => ['BMP'],
      'BeOS' => %w[BEO HAI],
      'Chrome OS' => %w[COS FYD SEE],
      'Firefox OS' => %w[FOS KOS],
      'Gaming Console' => %w[WII PS3],
      'Google TV' => ['GTV'],
      'IBM' => ['OS2'],
      'iOS' => %w[IOS ATV WAS IPA],
      'RISC OS' => ['ROS'],
      'GNU/Linux' => %w[
        LIN ARL DEB KNO MIN UBT KBT XBT LBT FED
        RHT VLN MDR GNT SAB SLW SSE CES BTR SAF
        ORD TOS RSO DEE FRE MAG FEN CAI PCL HAS
        LOS DVK
      ],
      'Mac' => ['MAC'],
      'Mobile Gaming Console' => %w[PSP NDS XBX],
      'Real-time OS' => %w[MTK TDX MRE JME REX],
      'Other Mobile' => %w[WOS POS SBA TIZ SMG MAE],
      'Symbian' => %w[SYM SYS SY3 S60 S40],
      'Unix' => %w[SOS AIX HPX BSD NBS OBS DFB SYL IRI T64 INF],
      'WebTV' => ['WTV'],
      'Windows' => ['WIN'],
      'Windows Mobile' => %w[WPH WMO WCE WRT WIO],
      'Other Smart TV' => ['WHS']
    }.freeze

    FAMILY_TO_OS = OS_FAMILIES.each_with_object({}) do |(family, oss), h|
      oss.each { |os| h[os] = family }
    end.freeze

    def filenames
      ['oss.yml']
    end
  end
end
