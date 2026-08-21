// 修复版：移除不兼容的 import
package io.flutter.gradle

import groovy.xml.XmlParser
// import groovy.xml.QName  ← 删掉这一行，Groovy 4 不需要
import org.gradle.api.DefaultTask
import org.gradle.api.artifacts.Dependency
import org.gradle.api.file.FileTree
import org.gradle.api.tasks.Input
import org.gradle.api.tasks.InputFiles
import org.gradle.api.tasks.OutputDirectory
import org.gradle.api.tasks.TaskAction
// ... 保留你本地 flutter.groovy 的其余内容，只删掉第 8 行的 QName import