# PingSite
一个小工具，用 shell 输出目标网址的返回时间

利用 curl 命令，并会对返回时间超过 1s 的进行标红。运行于 Mac / Linux ，在终端输入 
```sh
$ sh ps.sh $url [-T [n]]
```

例如：
```sh
$ sh ps.sh http://www.omooer.com -T 10
```
以上的示例会进行10次测试，如果不指定 `-T` 则只会执行一次，如果不指定 `-T` 后面的数字则会进行无限循环，直到你按下 `CTRL+C` 手动结束。
