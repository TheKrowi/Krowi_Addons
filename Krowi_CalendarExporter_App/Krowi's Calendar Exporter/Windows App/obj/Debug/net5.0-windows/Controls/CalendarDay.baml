   M S B A M L   `   `   `  ����F  BWindows App, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null;"clr-namespace:Windows_App.ControlsWindows_App.Controls  5   6  &     Windows_App.Controls.CalendarDay   6   \ XPresentationFramework, Version=5.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35e aSystem.Windows.Controls.Ribbon, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089W SPresentationCore, Version=5.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35R NWindowsBase, Version=5.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35F 9http://schemas.microsoft.com/winfx/2006/xaml/presentation     69   R NSystem.Xaml, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089:x,http://schemas.microsoft.com/winfx/2006/xaml     6{   Jmc;http://schemas.openxmlformats.org/markup-compatibility/2006     6�   @d2http://schemas.microsoft.com/expression/blend/2008     6�   4local"clr-namespace:Windows_App.Controls     66    � 	Resources  5         BackgroundImage �� Source �� 
SourceRect  ShadowTopImage  ShadowBottomImage��%  &	        &	 Q     &	 �     �� 5   
   $% ../Media/CalendarBackground.png��60   $ 0, 0, 90, 90��6Y   �� 5   
   $" ../Media/CalendarShadows.png��6/   $ 360, 0, 90, 45��6U   �� 5   
   $" ../Media/CalendarShadows.png��62   $ 90, 180, 90, 45��6X   5      .��5      �  � RowDefinitions 5   
   �� 5	      �� 5
      .+�5   
   �� $��2��6   #���   6!   $
��Fill=�6L   �� 5   
   $��2��6   $
��Bold"�6!   
�������$
��Left=�6F   $	��Top=�6a    �� ContentStringFormat$ dd��6�   ��6y   ��  �� Path$
 Date� �� RelativeSource ��  �� AncestorType UserControl �� FallbackValue$ 99��6�   �� 5   
   -   5        	 ��Name$	 ShadowTopImage��5      #���  6(   $
��Fill=�6R   
 J� RenderTransformOrigin$
 0.5, 0.5&�6a   �� 5   
   -   5        $	 ShadowBottomImage��5      $��1��6+   #���  68   $
��Fill=�6e   $
 0.5, 0.5&�6t   5      5      5      