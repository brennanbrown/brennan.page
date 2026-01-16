# brennan.page Homelab - TODO

## 🎯 Current Priority

### Phase 1 - Foundation ✅ (COMPLETED)
- [x] Set up repository structure
- [x] Configure SSH access and security
- [x] Install Docker and Docker Compose
- [x] Set up UFW firewall
- [x] Create Docker networks (caddy, internal_db, monitoring)
- [x] Deploy Caddy reverse proxy with SSL
- [x] Deploy Portainer (docker.brennan.page)
- [x] Deploy FileBrowser (files.brennan.page)
- [x] Create landing page (brennan.page)
- [x] Set up backup scripts and automation
- [x] Create health monitoring scripts

### Phase 2 - Monitoring & Documentation ✅ (COMPLETED)
- [x] Replace Glances with lightweight monitoring solution
- [x] Deploy MkDocs wiki (wiki.brennan.page)
- [x] Create comprehensive service documentation
- [x] Set up automated wiki deployment
- [x] Configure service health dashboards
- [x] Fix monitoring service proxy issues
- [x] Complete Phase 2 documentation in wiki
- [x] Set up Portainer admin account

### Phase 3 - Personal Productivity � (NEXT)
- [ ] Deploy PostgreSQL database
- [ ] Deploy Vikunja (tasks.brennan.page)
- [ ] Deploy HedgeDoc (notes.brennan.page)
- [ ] Deploy Linkding (bookmarks.brennan.page)
- [ ] Deploy Navidrome (music.brennan.page)
- [ ] Configure service authentication
- [ ] Set up database backups

### Phase 4 - Content & Community 📋 (PLANNED)
- [ ] Deploy WriteFreely (blog.brennan.page)
- [ ] Deploy Flarum (forum.brennan.page)
- [ ] Deploy FreshRSS (rss.brennan.page)
- [ ] Set up user authentication and management

### Phase 5 - Utilities 📋 (PLANNED)
- [ ] Deploy Plik (share.brennan.page)
- [ ] Deploy Rallly (poll.brennan.page)
- [ ] Configure service integrations

### Phase 6 - Optimization & Maintenance 📋 (PLANNED)
- [ ] Set up swap file (4GB)
- [ ] Configure log rotation
- [ ] Optimize Docker resource usage
- [ ] Set up automated security updates
- [ ] Configure backup verification
- [ ] Performance tuning and monitoring

---

## 🔧 Technical Tasks

### Immediate Fixes
- [x] Fix Glances web interface (replaced with custom monitoring solution)
- [x] Configure proper CORS headers for APIs
- [x] Set up proper error pages for Caddy
- [x] Optimize Caddy configuration for HTTP/3

### Documentation
- [x] Complete MkDocs site structure
- [x] Write service-specific documentation
- [x] Create deployment runbooks
- [x] Document backup procedures
- [x] Create troubleshooting guides

### Security
- [ ] Configure fail2ban for SSH protection
- [ ] Set up automated security scanning
- [ ] Configure rate limiting on Caddy
- [ ] Set up SSL certificate monitoring
- [ ] Create security audit procedures

### Monitoring & Alerting
- [ ] Configure comprehensive health checks
- [ ] Set up email notifications for failures
- [ ] Create performance dashboards
- [ ] Set up log aggregation
- [ ] Configure uptime monitoring

---

## 🏗️ Infrastructure Improvements

### Resource Management
- [ ] Implement memory usage alerts
- [ ] Set up container resource limits
- [ ] Configure automatic cleanup of unused images
- [ ] Set up disk space monitoring
- [ ] Optimize Docker storage usage

### Backup & Recovery
- [ ] Test backup restoration procedures
- [ ] Set up offsite backup replication
- [ ] Configure backup encryption
- [ ] Create disaster recovery documentation
- [ ] Set up backup verification alerts

### Network & Performance
- [ ] Configure CDN for static assets
- [ ] Optimize SSL/TLS configuration
- [ ] Set up DNS monitoring
- [ ] Configure network segmentation
- [ ] Optimize database performance

---

## 📚 Content & Features

### Wiki Development
- [ ] Create comprehensive service documentation
- [ ] Add architecture diagrams
- [ ] Write getting started guides
- [ ] Create API documentation
- [ ] Add video tutorials

### Landing Page Enhancements
- [ ] Add real-time system stats
- [ ] Create service status indicators
- [ ] Add technology stack showcase
- [ ] Implement dark/light theme toggle
- [ ] Add contact information

### Community Features
- [ ] Set up user registration system
- [ ] Create community guidelines
- [ ] Configure content moderation
- [ ] Set up notification system
- [ ] Create user profiles

---

## 🔄 Maintenance Tasks

### Daily
- [ ] Review system health dashboard
- [ ] Check service availability
- [ ] Review error logs
- [ ] Monitor resource usage

### Weekly
- [ ] Apply system updates
- [ ] Review backup logs
- [ ] Clean up old logs
- [ ] Update documentation

### Monthly
- [ ] Security audit
- [ ] Performance review
- [ ] Backup restoration test
- [ ] Update Docker images
- [ ] Review and optimize configurations

---

## 🎯 Stretch Goals

### Advanced Features
- [ ] Set up GitLab CI/CD pipeline
- [ ] Configure Kubernetes cluster
- [ ] Implement zero-downtime deployments
- [ ] Set up multi-region redundancy
- [ ] Create mobile applications

### Integrations
- [ ] Configure LDAP authentication
- [ ] Set up SSO integration
- [ ] Add API gateway
- [ ] Configure message queue
- [ ] Set up monitoring with Prometheus

### Automation
- [ ] Implement infrastructure as code with Terraform
- [ ] Set up configuration management
- [ ] Create automated testing pipeline
- [ ] Configure blue-green deployments
- [ ] Set up auto-scaling

---

## 📝 Notes

### Resource Budget
- **Total RAM**: 2GB (currently using ~500MB)
- **Available for new services**: ~1.5GB
- **Disk usage**: 3GB/67GB (plenty of space available)

### Priority Matrix
- **High Priority**: Phase 2 completion (monitoring & documentation)
- **Medium Priority**: Phase 3 services (productivity tools)
- **Low Priority**: Phase 4+ services (community features)

### Dependencies
- Shared PostgreSQL database needed for Phase 3 services
- SSL certificates automatically managed by Caddy
- All services depend on Docker networks being properly configured

---

*Last updated: 2026-01-16*  
*Next review: 2026-01-23*
