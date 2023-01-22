# xml
Data and stylesheets to maintain recipes for www.christmas-baking.com

After a redesign, as the site grew larger, and with a desire to off metric measurements, I needed a way to convert, index, and create pages. It became obviouse that recipes are one of the data structures that work extremely well in XML. They are semi-structured data: too unstructured for a database, but not free-form text either.

Since then, I've updated the CSS for the pages twice: first a design refresh and then moving to grid. Bot required only re-writing the .xslt files to coform to the new styles.

A perl script converts between American and metric weight measurements, both in the ingredients list and the directions.
