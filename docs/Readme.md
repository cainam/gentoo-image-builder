<script type="module">
	import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
	mermaid.initialize({
		startOnLoad: true,
		theme: 'dark'
	});
</script>


# gentoo-image-builder

This git repository is inspired by [Kubler](https://github.com/edannenberg/kubler) and keeps 
- kubler's build-root.sh script,
- the approach to create a builder and target image in tandem and
- [Gentoo](https://www.gentoo.org/)

The resulting images are incredibly small in size (e.g. the smallest busybox using alpine had a size of ~4.6MB, while the Gentoo-based busybox image is 2.6MB with room to shrink even further!)

Nevertheless I faced some quirks which made me replace kubler:
- kubler is made out of high quality shell scripts, but I found it difficult to quickly find issues and to understand the impact of changes in my build chain
- tags:
  - kubler is not flexible for image tags and custom tagging (e.g. tag nodejs image with the version of nodejs, not the portage tag)
  - ":latest" tag is always used while I want to avoid it completely
- lack of a central file which includes all my build dependencies
- as my own deployment is build around Ansible there is plenty of stuff in the scripts which can be done much shorter and more readable in Ansible playbooks

This solution is not (yet) implementing all the features of kubler, especially
- allowing different initial builders and 
- cross-compiling 

On the other hand it goes beyond kubler supporting
- not only kubler build images, but also
  - freely scripted ones and
  - direct pull/push of images from a registry (where it could be e.g. locally scanned before being used in a deployment)
- handles a set of images at once

The process is based on a central image definition structure which includes 
- the type of a build,
- the description how to build and
- the image it depends on.
  
An example can be found in the [examples folder](../examples).


## How the images are build
From Gentoo a first builder is created called builder-scratch which is used for images that are build "FROM scratch".
Each further image is then build using the builder of the image it is build FROM.

E.g.
<pre class="mermaid">
flowchart TD; 
  stage3-->builder-core;
  builder-core-->builder-scratch;
  builder-scratch-->base;
  builder-scratch-->builder-base;
  builder-base-->go
  builder-base-->builder-go
  builder-go-->descheduler
  builder-go-->builder-descheduler
</pre>

