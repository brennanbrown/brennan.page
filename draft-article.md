# Computing for the Apocalypse 

As I wrote about recently, I am not a full-stack developer. I have spent over a decade focusing on static-site generators like Jekyll, Hugo, and 11ty and other front-end work. All of my work online is hosted with services like GitHub Pages, Netlify, or Vercel. I'm grateful for these services, because they're free and accessible. But these are still platforms I don't which could close shop anytime. It's a fantastic way to get started, but it ultimately goes against the IndieWeb ethos.

I have over two dozen different projects online with Netlify, for instance, ranging from my main site [https://brennan.day](https://brennan.day) to a bunch of other projects, which you can view in [my portfolio](https://berryhouse.ca/portfolio). It's extremely cool how easy it is to take a git repo full of my files and have it online in a matter of minutes. 

But Netlify is far from perfect. Does anybody [remember GatsbyJS](https://github.com/gatsbyjs/gatsby/discussions/39062)? I was so excited to have a static-site framework that used React (mostly because everybody told me I needed to learn React to be employable, but that's beside the point). After [Gatsby was bought by Netlify](https://www.netlify.com/press/netlify-acquires-gatsby-inc-to-accelerate-adoption-of-composable-web-architectures/), the project died. It was clearly an acquihire but never stated as such.

This is just one problematic example of many, and proof that I need to start seriously thinking about running and hosting my own sites on my own bare metal. And that requires learning the back-end in earnest. 

Why now? I don't need to remind you that our world is in an fragile and unstable state right now. It would do everyone good to learn how to grow your own vegetables, sew your own clothing, learn proper first aid, and cultivate your own sourdough starter. Regardless of the state of the world, homesteading and permaculture are interesting and useful hobbies. 

I'm not the first person to work on the concept of digital homesteading, the idea of [permacomputing](https://permacomputing.net/) has been around for a long while. I especially enjoy [Devine Lu Linvega's write-up](https://wiki.xxiivv.com/site/permacomputing.html) on the subject.


## Actual Logistics

Despite graduating in April, I still have quite a few unused perks in my [GitHub Student Developer Pack](https://education.github.com/pack) (which, by the way, you should definitely apply for if you're in school, even if you're not into computer science or programming). One of these perks is $200 in credits on DigitalOcean for a year. I've tried out DigitalOcean in the past, but don't currently use it for anything because it is overkill for my simple projects. 

But this was a perfect opportunity for me to finally learn about cloud computing, databases, and devops with Docker and Caddy and break things without worry before transitioning over to using my own actual machines. My credits roughly translate to ~$16/mth which would buy me: 2 GB Memory / 1 Intel vCPU / 70 GB SSD Disk / running Ubuntu 24.04 (LTS) x64.

Going back to digital homesteading, my idea is this: I want to have a homelab monorepo which uses several different software applications in containers with Docker. I want to primarily have a machine that would take care of everything for me in the event that I have electricity but no Internet, but on the offchance the Internet survives the apocalypse, I also want community features as well. 

Here's what I have, so far:

### Core Infrastructure

- **brennan.page** -  Landing page with service status dashboard
- **docker.brennan.page** - [Portainer](https://portainer.io/) Docker management UI
- **monitor.brennan.page** - System monitoring with real-time stats
- **files.brennan.page** - [FileBrowser](https://filebrowser.org/) file management interface
- **wiki.brennan.page** - Git-backed static documentation wiki

### Productivity

- **tasks.brennan.page** - [Vikunja](https://vikunja.io/) task management system
- **notes.brennan.page** - [HedgeDoc](https://hedgedoc.org/) collaborative markdown editing
- **bookmarks.brennan.page** - [Linkding](https://linkding.app/) bookmark manager
- **music.brennan.page** - [Navidrome](https://navidrome.org/) music streaming service

### Community Platforms

- **blog.brennan.page** - [WriteFreely](https://writefreely.org/) minimalist blogging platform
- **forum.brennan.page** - [Flarum](https://flarum.org/) community discussion forum
- **rss.brennan.page** - [FreshRSS](https://freshrss.org/) feed aggregator
- **share.brennan.page** – [Plik](https://plik.io/) temporary file sharing
- **poll.brennan.page** – [Rallly](https://rallly.app/) meeting/poll scheduler

Due to the rather weak specs, I didn't have enough overhead to implement certain software I wanted to, like [Jellyfin](https://jellyfin.org/) for media, but this was certainly a good-enough start. The important thing was learning how to use all of this stuff, and keeping track of my learning with the wiki and monitoring that would be in the server itself.

## Implementation

What started as a philosophical exploration quickly became practical education in backend development and systems administration. I broke the project into distinct phases.

### Phase 1: Foundation Infrastructure

The first step was establishing the core infrastructure. This meant setting up Docker as the container runtime, Caddy as a reverse proxy with automatic HTTPS, and a few management tools like Portainer for Docker management and FileBrowser for file ops. I created a simple landing page for all services on the root domain.

### Phase 2: Monitoring and Documentation

You can't manage what you can't measure. I implemented a monitoring system and a Git-backed wiki using MkDocs. Every configuration, troubleshooting step, and architectural decision is (supposedly) documented there. 

Everything follows a local-first development workflow: I write content locally in Markdown, build it into a static site, and deploy it via rsync to the server.

### Phase 3: Personal Productivity

I moved on to implementing tools for personal productivity. This required setting up a shared PostgreSQL database to serve multiple applications. I deployed Vikunja for task management, HedgeDoc for collaborative note-taking, Linkding for bookmark management, and Navidrome for music streaming. Each service is containerized with proper resource limits and network isolation.

## Architecture and Constraints

Working with a 2GB RAM constraint taught me lessons in resource optimization. It took me back to the days I was a teenager using a similarly-specced machine bought from Kijiji. The infrastructure currently runs on approximately 800MB of RAM usage (40% of available allocation), leaving headroom for growth.

### Resource Management Strategy

- **Memory Limits**: Every container has explicit memory limits to prevent runaway usage
- **Shared Database**: Instead of separate databases per service, I use a single PostgreSQL instance with multiple databases and users (though certain services require different database schemas)
- **Lightweight Images**: I prefer Alpine-based containers for their minimal footprint
- **Network Segmentation**: Docker networks are organized by function (caddy, internal_db, monitoring)

### Security Considerations

The project implements good-enough security practices:
- SSH key authentication only (no password auth)
- UFW firewall with minimal open ports
- Docker network isolation between services
- Automatic SSL certificates via Caddy

### Local-First

All configurations are written and tested locally before deployment. The Git repository serves as the single source of truth, with the server serving as a deployment target.  Why?

- **Version Control**: Every change is tracked and can be rolled back
- **Offline Development**: I can work on configurations without internet access
- **Disaster Recovery**: The entire infrastructure can be rebuilt from the Git repository

## Conclusion

My current system hosts 11 active containers serving 8 different services, all with HTTPS certificates and monitoring. Response times are consistently under 200ms, isn't that impressive?

It's nice that now all my data resides on infrastructure I control, and there's no third-party data collection or advertising tracking. I'm not locked into any particular service provider's roadmap.

I want to create ecosystems of services that work together, and yet have systems that can operate independently. And like our real world, it's important to make efficient use of limited resources, and to use open-source tools that can be endlessly modified and extended for our unknown future.

---

Of course, this isn't actually everything. I am still reliant on domain name registrars, payment processors, and a thousand other things. I've already quoted Carl Sagan previously, that if you want to bake an apple pie, you must first invent the universe. There is a lot at play here that aligns with that thinking. On the other hand, there is already so much that's here for us to use. 

The homelab project isn't about achieving complete digital independence - that's an unrealistic goal for most people. Instead, it's about taking meaningful steps toward digital resilience, learning valuable skills, and building systems that align with my values. And in a world that feels increasingly fragile, having the knowledge and ability to maintain your own digital infrastructure feels like a radical act of hope. 