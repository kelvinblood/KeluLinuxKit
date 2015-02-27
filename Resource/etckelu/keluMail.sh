#!/bin/bash

nowTime=`date +%Y-%m-%d_%H:%M`
myMailAddr='admin@kelu.org'
dailyReportFile="/var/log/daily-report/$nowTime.log"
mailPath='/etc/kelu'
echo '
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<title>kelu.org daily-report</title>
<meta content="text/html; charset=utf-8" http-equiv="Content-Type" />
</head>
<body marginheight="0" topmargin="0" marginwidth="0" bgcolor="#c5c5c5" leftmargin="0">
<table cellspacing="0" border="0" height="100%" style=" background-color: #fafafa;" cellpadding="0" width="100%">
  <tr>
    <td valign="top">
      <!-- main table -->
      <table cellspacing="0" border="0" align="center" cellpadding="0" width="675">
        <!-- note -->
        <!-- / note -->
        <!-- header -->
        <tr>
          <td valign="top">
            <table cellspacing="0" border="0" align="center" cellpadding="0" width="675">
              <!-- top -->
              <tr>
                <td height="9" valign="top"> </td>
              </tr>
              <!-- / top -->
              <!-- middle -->
              <tr>
                <td valign="top">
                  <table cellspacing="0" border="0" cellpadding="0" width="675">
                    <tr>
                      <td valign="top" width="5"> </td>
                      <td height="90" valign="top">
                        <table cellspacing="0" border="0" height="90" cellpadding="0" width="665">
                          <tr>
                            <td class="header-content" height="90" valign="top" style="background-color: #bbcedd; ">
                              <table cellspacing="0" border="0" height="90" cellpadding="0" width="665">
                                <td class="main-title" align="center" valign="middle" width="545" style="color: #4c545b; font-family: Georgia, serif; font-size: 35px; font-weight: bold; font-style: italic;"> VPS 每日报告' > $dailyReportFile
                                  echo "$nowTime" >> $dailyReportFile
                                  echo '  </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                      </table>
                    </td>
                    <td valign="top" width="5"> </td>
                  </tr>
                </table>
              </td>
            </tr>
            <!-- / middle -->
            <!-- botom -->
            <tr>
              <td height="35" valign="top"> </td>
            </tr>
            <!-- / bottom -->
          </table>
        </td>
      </tr>
      <!-- / header -->
      <!-- content -->
      <tr>
        <td valign="top">
          <table cellspacing="0" border="0" align="center" cellpadding="0" width="670">
            <!-- article title -->
            <tr>
              <td valign="top"> </td>
            </tr>
            <tr>
              <td class="article-title" height="30" valign="middle" style="text-transform: uppercase; font-family: Georgia, serif; font-size: 16px; color: #2b2b2b; font-style: italic; border-bottom: 1px solid #c1c1c1;"> 网络统计</td>
            </tr>
            <!-- / article title -->
            <!-- article -->
            <tr>
              <td class="copy" valign="top" style="font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #2b2b2b; line-height: 18px;"> <br />
                <pre>'>> $dailyReportFile
$mailPath/StaticsScript/keluNetSum.sh >> $dailyReportFile
echo '</pre> <br />
              </td>
            </tr>
            <!-- / article -->
            <!-- article title -->
            <tr>
              <td valign="top"> </td>
            </tr>
            <tr>
              <td class="article-title" height="30" valign="middle" style="text-transform: uppercase; font-family: Georgia, serif; font-size: 16px; color: #2b2b2b; font-style: italic; border-bottom: 1px solid #c1c1c1;"> CPU统计 </td>
            </tr>
            <!-- / article title -->
            <!-- article -->
            <tr>
              <td class="copy" valign="top" style="font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #2b2b2b; line-height: 18px;"> <br />
                <pre>'>>$dailyReportFile
$mailPath/StaticsScript/keluSysSum.sh >> $dailyReportFile
echo '</pre> <br />
              </td>
            </tr>
            <!-- / article -->
            <!-- article title -->
            <tr>
              <td valign="top">  </td>
            </tr>
            <tr>
              <td class="article-title" height="30" valign="middle" style="text-transform: uppercase; font-family: Georgia, serif; font-size: 16px; color: #2b2b2b; font-style: italic; border-bottom: 1px solid #c1c1c1;"> PPTP统计 </td>
            </tr>
            <!-- / article title -->
            <!-- article -->
            <tr>
              <td class="copy" valign="top" style="font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #2b2b2b; line-height: 18px;"> <br />
                <pre>'>>$dailyReportFile
$mailPath/StaticsScript/keluPPTPSum.sh>>$dailyReportFile
echo '</pre><br />
              </td>
            </tr>
            <tr>
              <td valign="middle" height="30" style="text-transform: uppercase; font-family: Georgia, serif; font-size: 16px; color: #2b2b2b; font-style: italic; border-bottom: 1px solid #c1c1c1;" class="article-title"> 实时情报 </td>
            </tr>
            <tr>
              <td valign="top" style="font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #2b2b2b; line-height: 18px;" class="copy"> <br>
                <pre>'>>$dailyReportFile
$mailPath/keluReal.sh >> $dailyReportFile
echo ' </pre>
                <br>
              </td>
            </tr>
            <!-- / article -->
          </table>
        </td>
      </tr>
      <!-- / content -->
      <!-- footer -->
      <tr>
        <td valign="top">
          <table cellspacing="0" border="0" cellpadding="0" width="675">
            <tr>
              <td valign="top"> </td>
            </tr>
            <tr>
              <td align="center" class="footer" valign="top" style="font-family: Arial, Helvetica, sans-serif; font-size: 11px; color: #2b2b2b; line-height: 18px;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td height="15"></td>
                  </tr>
                </table>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <!-- / footer -->
    </table>
    <!-- / main table -->
  </td>
</tr>
</table>
</body>
</html>' >> $dailyReportFile

mutt -s "VPS-每日报告-$nowTime" $myMailAddr < $dailyReportFile

rm -R $dailyReportFile
