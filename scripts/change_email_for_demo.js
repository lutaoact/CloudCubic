db.users.update({orgId: ObjectId('5438f983f26f910320e27f38'), role: 'admin'}, {$set: {email: 'demo_admin@cloud3edu.com'}});
db.users.update({orgId: ObjectId('5438f983f26f910320e27f38'), role: 'teacher', email: 'lidawei@myemails.com'}, {$set: {email: 'demo_teacher@cloud3edu.com'}});
db.users.update({orgId: ObjectId('5438f983f26f910320e27f38'), role: 'student', email: 'zhang@qq.cloud3edu.com'}, {$set: {email: 'demo_student@cloud3edu.com'}})
