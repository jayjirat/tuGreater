import 'package:flutter/material.dart';

class ThemeTesterPage extends StatefulWidget {
  const ThemeTesterPage({Key? key}) : super(key: key);

  @override
  State<ThemeTesterPage> createState() => _ThemeTesterPageState();
}

class _ThemeTesterPageState extends State<ThemeTesterPage> {
  bool _switchValue = false;
  bool _checkboxValue = false;
  double _sliderValue = 0.5;
  int _selectedRadio = 0;
  final TextEditingController _textController = TextEditingController(text: "Theme test text");
  List<bool> _toggleSelections = [true, false, false];
  
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Tester'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Typography Section
              const Text('Typography', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(),
              Text('Headline Large', style: theme.textTheme.headlineLarge),
              Text('Headline Medium', style: theme.textTheme.headlineMedium),
              Text('Headline Small', style: theme.textTheme.headlineSmall),
              Text('Title Large', style: theme.textTheme.titleLarge),
              Text('Title Medium', style: theme.textTheme.titleMedium),
              Text('Title Small', style: theme.textTheme.titleSmall),
              Text('Body Large', style: theme.textTheme.bodyLarge),
              Text('Body Medium', style: theme.textTheme.bodyMedium),
              Text('Body Small', style: theme.textTheme.bodySmall),
              const SizedBox(height: 24),

              // Buttons Section
              const Text('Buttons', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Elevated Button'),
                  ),
                  FilledButton(
                    onPressed: () {},
                    child: const Text('Filled Button'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined Button'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Text Button'),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Input Fields
              const Text('Input Fields', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Text Field Label',
                  hintText: 'Hint text',
                  helperText: 'Helper text',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: 'Option 1',
                items: ['Option 1', 'Option 2', 'Option 3']
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),

              // Selection Controls
              const Text('Selection Controls', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(),
              Row(
                children: [
                  Checkbox(
                    value: _checkboxValue,
                    onChanged: (value) {
                      setState(() {
                        _checkboxValue = value!;
                      });
                    },
                  ),
                  const Text('Checkbox'),
                  const SizedBox(width: 16),
                  Switch(
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                  ),
                  const Text('Switch'),
                ],
              ),
              Slider(
                value: _sliderValue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
              ),
              Radio<int>(
                value: 0,
                groupValue: _selectedRadio,
                onChanged: (value) {
                  setState(() {
                    _selectedRadio = value!;
                  });
                },
              ),
              Radio<int>(
                value: 1,
                groupValue: _selectedRadio,
                onChanged: (value) {
                  setState(() {
                    _selectedRadio = value!;
                  });
                },
              ),
              ToggleButtons(
                isSelected: _toggleSelections,
                onPressed: (index) {
                  setState(() {
                    for (int i = 0; i < _toggleSelections.length; i++) {
                      _toggleSelections[i] = i == index;
                    }
                  });
                },
                children: const [
                  Icon(Icons.format_bold),
                  Icon(Icons.format_italic),
                  Icon(Icons.format_underline),
                ],
              ),
              const SizedBox(height: 24),

              // Cards and Containers
              const Text('Cards & Containers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Card Title', style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      const Text('This is a card widget that uses the theme\'s card color and elevation.'),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('Action 1'),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Action 2'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('This is a container with a border'),
              ),
              const SizedBox(height: 24),

              // Progress Indicators
              const Text('Progress Indicators', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(),
              const LinearProgressIndicator(),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 24),

              // Chips
              const Text('Chips', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Divider(),
              Wrap(
                spacing: 8,
                children: [
                  Chip(
                    label: const Text('Basic Chip'),
                    onDeleted: () {},
                  ),
                  const FilterChip(
                    label: Text('Filter Chip'),
                    selected: true,
                    onSelected: null,
                  ),
                  InputChip(
                    label: const Text('Input Chip'),
                    onDeleted: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.primaryColor,
              ),
              child: const Text(
                'Drawer Header',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        onTap: (_) {},
      ),
    );
  }
}