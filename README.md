В разработке...

SAPR(САПР) - Система Атоматизированного Прочностного Расчета
Кратко о проекте: Учитывая вводные параметры система расчитывает результаты воздействия нагрузок на стержни.
Входные параметры: стержневая система, характеристики каждого стержня(длина, площадь поперечного сечения, модуль упругости, допускаемое
напряжение), опоры, нагрузки на стержни.
Выходные пармаетры: продольные силы, нормальные напряжения, перемещения стержней

Проект разрабатывается для университетского курса "Компьютерная механика"

Техническое задание на разработку системы автоматизации прочностных расчётов стержневых систем, испытывающих растяжение-сжатие
1. Требования к конструкции
Конструкция должна представлять собой плоскую стержневую систему, составленную из
прямолинейных стержней, последовательно соединённых друг с другом вдоль общей оси.
Каждый стержень i характеризуется длиной Li
, площадью поперечного сечения Ai
.
Материал стержней должен характеризоваться модулем упругости Ei
, допускаемым
напряжением [ ] σ i
.

2. Требования к нагрузкам
На любое сечение конструкции могут быть наложены нулевые кинематические граничные
условия (жёсткие опоры), запрещающие перемещения и повороты этих сечений во всех
направлениях.
Конструкция может быть нагружена в глобальных узлах j статическими сосредоточенными
продольными усилиями Fj
.
Каждый стержень конструкции может быть нагружен постоянной вдоль его оси статической
погонной нагрузкой qi
.

3. Требования к задачам
Система должна обеспечивать решение линейной задачи статики для плоских стержневых
конструкций.

4. Общесистемные требования (Опционально)
Система должна работать на персональных компьютерах, работающих под управлением
операционной системы Microsoft Windows.

5. Требования к системе
   
  5.1. Требования к препроцессору
Препроцессор системы должен обеспечивать:
- ввод массивов данных, описывающих конструкцию и внешние воздействия;
- формальную диагностику данных, описывающих конструкцию и внешние воздействия;
- визуализацию конструкции и нагрузок;
- формирование файла проекта.

  5.2. Требования к процессору
Процессор системы должен обеспечивать расчёт компонент напряжённо-деформированного
состояния конструкции (продольные силы Nx
, нормальные напряжения σx
, перемещения ux).

  5.3. Требования к постпроцессору
Постпроцессор системы должен обеспечивать:
- формирование файла результатов расчёта;
- анализ результатов расчёта;
- отображение результатов расчёта в табличном виде;
- возможность получения всех компонент напряжённо-деформированного состояния в
конкретном сечении конструкции;
- отображение результатов расчёта в виде графиков, на оси ординат которых отложены
интересующие пользователя компоненты напряжённо-деформированного состояния
конструкции, а на оси абсцисс – локальные координаты стержней;
- отображение результатов расчёта на конструкции в виде эпюр компонент напряжённодеформированного состояния. 
