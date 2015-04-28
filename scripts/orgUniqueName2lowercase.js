/**
 * Created by pengchengbi on 1/19/15.
 */
db.organizations.find().forEach(
  function(org) {
    org.uniqueName = org.uniqueName.toLowerCase();
    db.organizations.save(org);
  });