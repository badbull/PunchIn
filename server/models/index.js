/**
 * Created by Artsi on 20/04/16.
 */
var Sequelize = require('sequelize');

// initialize database connection
var sequelize = new Sequelize('mysql://punchin:siika112@82.196.15.60/punchin');

// load models
var models = [
    'Info',
    'Lessons',
    'Students',
    'Courses',
    'Attendants'
];
models.forEach(function (model) {
    module.exports[model] = sequelize.import(__dirname + '/' + model);
});

// describe relationships
(function (m) {
    m.Lessons.belongsTo(m.Info, {foreignKey: 'class_id'});
    m.Info.hasMany(m.Lessons, {foreignKey: 'class_id'});

    m.Lessons.belongsToMany(m.Students, {through: 'attendants', timestamps: false, foreignKey: 'lessons_id'});
    m.Students.belongsToMany(m.Lessons, {through: 'attendants', timestamps: false, foreignKey: 'student_id'});

    m.Courses.belongsToMany(m.Students, {through: 'student_courses', timestamps: false, foreignKey: 'course_id'});
    m.Students.belongsToMany(m.Courses, {through: 'student_courses', timestamps: false, foreignKey: 'student_id'});

    m.Lessons.belongsTo(m.Courses, {foreignKey: 'course_id'});
    m.Courses.hasMany(m.Lessons, {foreignKey: 'course_id'});

    m.Attendants.hasMany(m.Lessons, {foreignKey: 'lessons_id'});
    m.Attendants.hasMany(m.Students, {foreignKey: 'student_id'});
})(module.exports);

// export connection
module.exports.sequelize = sequelize;
