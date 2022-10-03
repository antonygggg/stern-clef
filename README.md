## Stern for Compact Log Event Format logs


Tail Kubernetes logs from multiple pods in [CLEF](https://clef-json.org) json format


<br/>

### Usage:


#### In order to use this you need to have [Stern](https://github.com/stern/stern) installed globally (build and tested with [Stern 1.22.0](https://github.com/stern/stern/releases/tag/v1.22.0))

```
stern_clef.sh pod-query [flags_without_tempalte]
```

<br/>

examples

```
stern_clef.sh backend
```

```
stern_clef.sh backend-859348d699 -s 5m
```

<br/>

#### To use any other custom template pass the `--template` argument , for Stern default template pass an empty string value and don't pass `-o`, `--output` argument



```
stern_clef.sh pod-query [flags_without_tempalte] --template='<TEMPLATE>'
```


<br/>

example

```
stern_clef.sh backend --template=''
```

```
stern_clef.sh backend -s 5m --template='{{.Message}} ({{.Namespace}}/{{.PodName}}/{{.ContainerName}})'
```

<br/><br/>

Use Serilog to write structured compact log event format logs

https://github.com/serilog/serilog-formatting-compact#getting-started

Stern go templates examples

https://github.com/wercker/stern#examples

ANSI escape sequences and color codes

https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#8-16-colors

<br/>

### Read more:

https://clef-json.org/

https://github.com/stern/stern

https://github.com/serilog
