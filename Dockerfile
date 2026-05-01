FROM squidfunk/mkdocs-material
RUN pip install mkdocs-macros-plugin
RUN pip install mkdocs-glightbox
RUN pip install mkdocs-print-site-plugin
RUN pip install pymdown-extensions
RUN pip install mkdocs-mermaid2-plugin
RUN pip install mkdocs-toggle-sidebar-plugin



