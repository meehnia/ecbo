FROM squidfunk/mkdocs-material

RUN pip install mkdocs-macros-plugin \
    mkdocs-glightbox \
    mkdocs-print-site-plugin \
    pymdown-extensions \
    mkdocs-mermaid2-plugin \
    mkdocs-toggle-sidebar-plugin

WORKDIR /docs

COPY . /docs

EXPOSE 8000

CMD ["serve", "--dev-addr=0.0.0.0:8000"]



