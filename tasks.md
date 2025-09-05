## background

r2r is set up to start by running the docker compose in the docker folder, and i generally want to run the "full" version. (/workspace/docker/compose.full.yaml)

I have forked it into this repo and want to make some changes to what they have.

## things i want

- better handling of secrets instead of using .env for everything.
  - I'm modified the env files to not have anything sensitive in them. But i DO need to define several environmental variables for r2r to use: GOOGLE_API_KEY, GEMINI_API_KEY,NEXT_PUBLIC_R2R_DEFAULT_EMAIL,NEXT_PUBLIC_R2R_DEFAULT_PASSWORD.
  - i think docker secrets would be better. those secrets can (i think) point to files on the host outside of the versioned workspace, and so generally easier to protect from accidentally commiting.
- configuration is also a challenge with r2r, and there are a lot of knobs to adjust and control, and defaults i want to overwrite, but its pretty verbose and the project is very actively developed (hence my fork). I think using pydantic configuration/settings might be a good method
  - some examples of things i might want to do at some point: to managing the r2r.toml, compose ports, if i want to override and use another network, the various (de risked, where risky is in docker secrets) env files i might want to tweak. And the ability to integrate all that with what i do with docker secrets. The cli capability of pydantic config is a potentially very nice to have thing.
    - I don't need to implement all that right now though.
  - But right now you can see what the default values for r2r.toml are in `py/r2r/r2r.toml`, while i've made a lot of changes and additional call outs in `docker/user_configs/r2r.toml` used in the compose.
- a solution for doing development with r2r in other projects.
  - there is a lot of configuration that might need to be customized for each project since the r2r.toml is loaded on creation, not at runtime. So each project likely will need to create its own instance of r2r service. I could create a global service, but that would mean i couldnt have custom settings for a given project.
  - But I ALSO want to do development of those other projects in a containerized way (devcontainers). So i need some way of making it easy to integrate the services of my forked r2r with other projects i create.
    - I don't want to develop R2R in those projects (ie: edit the source code of how r2r works), rather I just want to have the ability to adjust configurations/settings and run my forked r2r with those adjustments, and have it work with/alongside a porjects devcontainer.
- I also want to be able to relatively easily sync/update the version of r2r on my fork with that of the original r2r.
  - So any changes I make to r2r should be as easy/straightforward to merge as possible.
    - I'll ramble some considerations that come to mind, though they may be completely off base, so please take with a grain of salt.
      - Not sure what the best way to do this is. Completely decoupling it all to a new directory is easiest because no conflict could happen. But because the source R2R is under so much development, assuptions and apis aren't guaranteed. So i might be surprise by changing behavior. Functional tests might work, but its a complex and very heavy project with large images, so build to test will take time. Inserting it into the code where changes will force merge resolution might work, but its hard to know the best way to resolve those if its fairly complex code.
