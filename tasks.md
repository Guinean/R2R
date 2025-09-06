## background

r2r is set up to start by running the docker compose in the docker folder, and i generally want to run the "full" version. (/workspace/docker/compose.full.yaml)

I have forked it into this repo and want to make some changes to what they have.

## things i want

### Improved R2R configuration control

#### Secrets

- use docker secrets instead of .env files for truly sensitive things (api keys, passwords.)
- use best practices around secrets (avoid reading to testing or otherwise risking them and making them no better than the env approach we're moving away from. Less is more and best practices exist for a reason.)

#### Configuration help

- help reviewing the config sections and approving / modifying them
  - when syncing the fork with the original
  - or when using the fork in a new project

### Ability to use the fork in other projects (where those projects do development in devcontainers)

- need to be able to run a distinct instance of the forked containers compose that is dedicated to a given project
- need to be able to use/tweak the configuration, which should be easier if we add config help to the fork.
- when using the fork in the project, it should just need to know the absolute directory of the projects docker secrets

## some musings on this

- better handling of secrets instead of using .env for everything.
  - I'm modified the env files to not have anything sensitive in them. But i DO need to define several environmental variables for r2r to use: GOOGLE_API_KEY, GEMINI_API_KEY,NEXT_PUBLIC_R2R_DEFAULT_EMAIL,NEXT_PUBLIC_R2R_DEFAULT_PASSWORD.
  - i think docker secrets would be better. those secrets can point to files on the host outside of the versioned workspace, and so generally easier to protect from accidentally commiting.
- configuration is also a challenge with r2r, and there are a lot of knobs to adjust and control, and defaults i want to overwrite
  - but its pretty verbose and the project is very actively developed (hence my fork). So sometimes new settings appear i need to account for, or existing settings have different meanings. So updating the fork and my interpretation of it needs extra care.
  - I think using <https://github.com/pydantic/pydantic-settings> , <https://docs.pydantic.dev/latest/concepts/pydantic_settings/> might be a good method. The cli capability of pydantic settings is a potentially very nice to have thing. The one thing to be careful of is i don't really know all the things R2R does about the settings, in that i don't really know the potential options, or how to validate some of the entries.
  - some examples of things i might want to do at some point:
    - ability to create different versions of the embedding or ingestion (etc) config portions of the r2r.toml and able to choose between presets or may specific tweaks. to managing the r2r.toml,
    - able to swap out the compose ports to something different than the defaults, or ability to use another network that the host so that I can leave the ports the same and not have different instances conflict,
    - some similar control over the r2r.env file as the toml. But here we will never add api keys or passwords as those will be in the docker secrets.
    - NOTE: I don't need to implement all that right now though.
  - But right now you can see what their default values for r2r.toml are in `py/r2r/r2r.toml`, while i've made a lot of changes and additional call outs in `docker/user_configs/r2r.toml`. The latter directory is what would be used by the docker compose in `/workspace/docker/compose.full.yaml`
- a solution for doing development with r2r in other projects.
  - there is a lot of configuration that might need to be customized for each project since the r2r.toml is loaded on creation, not at runtime. So each project likely will need to create its own instance of r2r service. I could create a global service, but that would mean i couldnt have custom settings for a given project.
  - But I ALSO want to do development of those other projects in a containerized way (devcontainers). So i need some way of making it easy to integrate the services of my forked r2r with other projects i create.
    - I don't want to develop R2R in those projects (ie: edit the source code of how r2r works), rather I just want to have the ability to adjust configurations/settings and run my forked r2r with those adjustments, and have it work with/alongside a porjects devcontainer.
- I also want to be able to relatively easily sync/update the version of r2r on my fork with that of the original r2r.
  - So any changes I make to r2r should be as easy/straightforward to merge as possible, and do so CORRECTLY knowing apis/setting semantics may shift.
