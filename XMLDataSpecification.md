# XML Data Specifications for Services API #

## Graph XML Response Structure ##

The graph structure is intended to ease a client's responsibility of rendering the graph by designating all of the relations. Unique identifiers (uid) are given to each node such that a reasonable client can easily track nodes across several requests without in-memory data structures. The uid will may allow a client to quickly find a node on an already drawn map (either partially or fully). This can reduce the complexity of drawing larger (higher degree) maps.

```
<graph center="[uid1]">
    <source id="[uid1]" title="[node-title]" len="[page-length]" is_disambiguation="false"|"true">
        <dest id="[uid2]"/>
        <dest id="[uid3]"/>
        ...
    </source>
    <source id="[uid2]" title="[node-title]"></source>
    ...
</graph>
```

## Search XML Response Structure ##

```
<search query="[phrase that was searched on]">
    <item id="[uid1]" title="[node-title]" />
    <item id="[uid2]" title="[node-title]" />
    ...
</search>
```

## Autocomplete XML Response Structure ##

```
<list phrase="[partial phrase that was searched on]">
    <item id="[uid1]" title="[title]" />
    <item id="[uid2]" title="[title]" />
    <item id="[uid3]" title="[title]" />
    ...
</list>
```

## Abstract Response Structure ##

```
<info id="[uid1]">
    <title>[title]</title>
    <abstract>[abstract of 50 words]</abstract>
    <link>[wikipedia url</link>
</info>
```