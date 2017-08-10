require"import"
import "android.text.method.ScrollingMovementMethod"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "http"
import "cjson"
import "java.io.File"

activity.setTitle("导出云音乐歌词")
activity.setTheme(R.Theme_Google)
activity.setContentView(loadlayout"layout")
t_p.setMovementMethod(ScrollingMovementMethod.getInstance()); 

path=t_path.text

b_start.onClick=function ()
  onStartClick()
end

function onStartClick()
  fl=File("/sdcard/netease/cloudmusic/Download/Lyric/").listFiles()
  for i=1,#fl do
    --print(i)
    filen=luajava.tostring(fl[i])
    --filen="/sdcard/netease/cloudmusic/Download/Lyric/407039301"
    printf("找到文件:"..filen)
    nr=io.open(filen):read("*a")
    lrc=cjson.decode(nr).lyric
    if lrc=="" then
      printf("未读取到歌词，跳过")
    else
      printf("读取到歌词:\n"..lrc)
      songName,artists=getInf(string.gsub(filen,"/sdcard/netease/cloudmusic/Download/Lyric/",""))
      if songName=="error" and artists=="error" then
        printf("error")
        break
      end
      printf("歌曲名:"..songName.."\n\n\n\n")
      art=""
      for i=1,#artists do
        if art=="" then
          art=artists[i]
        else
          art=art.." "..artists[i]
        end
      end
      fullname=art.." - "..songName..".lrc"
      fullname=string.gsub(fullname,"/"," ")
      fullname=string.gsub(fullname,"\\"," ")
      fullname=path..fullname
      printf(fullname)
      if file_exists(fullname) then
      else
        local f=io.open(fullname,"w")
        io.output(f)
        io.write(lrc)
        io.close(f)
      end
    end
  end
  print('finished')
end

function getInf(id)
  body,cookie,code,headers=http.get("http://music.163.com/api/song/detail/?id="..id.."&ids=["..id.."]")

  printf(body)
  if body=="" then
    return "error","error"
  end
  inf=cjson.decode(body)
  if inf.songs then
    songName=inf.songs[1].name
    printf("获得歌曲名:"..songName)
    artists={}
    for i=1,#inf.songs[1].artists do
      artists[i]=inf.songs[1].artists[i].name
      printf("新增艺术家:"..artists[i])
    end
    return songName,artists
  else
    printf(body)
    return "error",body
  end
end

function printf(str)
  t_p.text=t_p.text..str.."\n"
end

function file_exists(path)
  local f=io.open(path,'r')
  if f~=nil then io.close(f) return true else return false end
end